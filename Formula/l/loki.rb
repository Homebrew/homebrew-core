class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.9.0.tar.gz"
  sha256 "47b678408239019d85ad0d9ace5bd12304d2d315dec308a9b665ab34feef813a"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7300b5ef39068163b81a298c6013b327abb4b85aea1e198a172f2ee458cd6e28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13a6735cf1245d2e2bcc2dd9b51dc4c43b11448c702f39680ef38994923643a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1af7f08614981d347416c12483b858457d5ee3b28e13fbb9e420d3c0630cb8c9"
    sha256 cellar: :any_skip_relocation, ventura:        "fa7985857510c17b2e583aff523c12f296e6571c009cb11046dee4aff21da0eb"
    sha256 cellar: :any_skip_relocation, monterey:       "02e575b747f3860b4c0eae64b06ad1d90691efb54b29c8edd65fa1503ad7e24e"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdc08164f7086937cc46039e890bb593e434ff5acd38644c12435d27ec6a0219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de7a5f85f757af8fc9050fb916c7ed93f92af3538a074629f861907ad83f8acf"
  end

  depends_on "go" => :build

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

    fork { exec bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
