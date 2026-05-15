class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.2.tar.gz"
  sha256 "f91b7737cc0ca352dfb99e9307bc2f6a67135d6827922374ab4a31676d280790"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "990fa423f3f37f2f3301ec03a03d39d0bad44955961f9c8c06b06d2d4c89b4d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ed8ae479714ca4f3b315dd66fb55be3dc849596ebc67d28c3736e28cec12718"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce38de33be4272c7d982d1423de12c62c16139d863a0726410c2e9ecc6ba1f62"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ae46924f6320db54f30aebadbf9c8410b686db385f44be5b6a402facac2a526"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e99d50b50018b4404f35dc47bb55bf56d18b2ba8a22469175e7b4b6bf9e7ab48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5654c6525acdd177188693f669df76a7c2f355a2e2b3ffe4dca2fe33328f4bd3"
  end

  depends_on "go" => :build

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      inreplace "loki-local-config.yaml", "/tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"loki", "-config.file=#{etc}/loki-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/loki.log"
    error_log_path var/"log/loki.log"
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    spawn bin/"loki", "-config.file=loki-local-config.yaml"

    output = shell_output("curl --silent --retry 5 --retry-connrefused localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
