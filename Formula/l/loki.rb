class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/oss/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.10.tar.gz"
  sha256 "52e1a821de73d634a152e6737f7a4629dae830240015a2d6f244ccaaf3b13357"
  license "AGPL-3.0-only"
  compatibility_version 1
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cde78230ba6357072d5efe01d600030d1b5977990e7290321801344cd3f30134"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f94e884fe54ee88ff416e758e20a7fd0a8eac109d026875df989fe7c8d667bc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "183024f3a207ba378e970c7edb6d6f322a68f148506736ae4c2d1083b62dd0fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fd55d987769b271c2690b680fc5f8499abdf80751fc73b383060a5c40d782869"
    sha256 cellar: :any,                 x86_64_linux:      "ba00efff019df4d54472a5da45bd5432fbb0261adf008a1ef802dc0cf66783f4"
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
