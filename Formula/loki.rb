class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.7.4.tar.gz"
  sha256 "b5521c0d12699f59ddf48ff7eaacddaa56abe90da4579f35c18f0752fc8e95c0"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3357c95a448acfca1682a3d8bbb6c135a51925bff7ead639db14234920bb697"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94585a632ce78469a8974a17a89f9177d35c457bb5d1fa29ecf51d93e0b1ca34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71db02df29d3494b4602cfdbe7599a1a52753dd7136a45cdd09e7e6d8ef14ee1"
    sha256 cellar: :any_skip_relocation, ventura:        "52ab9cb750d3b9b5df9c5a75a05c4df6397851eb411a91bda2fe8b876e1a75fc"
    sha256 cellar: :any_skip_relocation, monterey:       "225fa879ba8c8c60244a57e4fbaf283d2d11019b264497fe16f1971b9aa79e43"
    sha256 cellar: :any_skip_relocation, big_sur:        "25df00c32d80ea19334143d911c4ca21bed869ac39bbf3b336a52458bcb9c2c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "846aa7d6a1ab7d2df91b2f13d57b67c90dbef6ee4c5ee716981efc87f9fcb313"
  end

  # TODO: Try `go@1.20` or newer on the next release
  depends_on "go@1.19" => :build

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
