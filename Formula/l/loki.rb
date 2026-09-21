class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/oss/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.8.tar.gz"
  sha256 "313a9c2de71ca7ffca1189f6ac2916073df36f498f2d6f77130d07bcd6fc5724"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d86d8a95745e215507e25992880d0059cf61ca12002ed9542d9ee0cc230dbd7c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee9115dda388654b11c81fc5f265f95d3a56d4bff5ea4637563d1c1328e5702c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "271f354e9acb72e4d090919735d27eadb09817170ed1a7138936377af382cbaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c640f80d9bf436de623c1484df3f16eda38583f4ae77418fcfccf7d8ce7f2023"
    sha256 cellar: :any,                 x86_64_linux:      "45c808534d151b6529a1cced5f32a5c00d4319d5ff4b0b3c457b17d0ce93b517"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args
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
