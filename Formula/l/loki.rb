class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v2.9.6.tar.gz"
  sha256 "d3642bb140dbaf766069a587ae6b966576304dfdda3a932bf6e9a79fc8146b17"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f642086588656e01ec94e389d170bded54ffd96d26655bc78d37f37b6461ac2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "509e1d4e71b2590ad9ae138c47a476df25c18385c00f8c025b027c2438f5d650"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05099e72be3a88bec2c94b96cfc6f32ea82888760d5c2cd33d49adfb29cb82d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "370e7ddd8437b8486ab6b5f673332b236ca15c515640cf744b0f95b6bf358ea3"
    sha256 cellar: :any_skip_relocation, ventura:        "020ece7846da99c65f790b5699a566dbf18f48d66de72d1bf3e948b229152651"
    sha256 cellar: :any_skip_relocation, monterey:       "e659d080a23eb4434ae3751a4774318a230856db196a6abf9d9ca920d7fb9e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9b0161936e867c1dd94fa78defb016dd6f3a1c0b6a8ef90df6c8ca9b7d3cb9b"
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

    fork { exec bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
