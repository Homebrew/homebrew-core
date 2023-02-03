class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.7.3.tar.gz"
  sha256 "07b7030576abf4ef63febf4dcddf95ff935aab6d9ab4fc0404322794d94bf3ee"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57c32ee7be2605dad06a98520e0e7e25ccffbe3f8a8f8094e38fcb7faa971eb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a623825275d7dc74acc5dc72dc39b0db5f8b2ce847e51a48febbe037aa978483"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b49dd02b645834595ba131a3761b9185d8ec09729dfaf203635e04b62c8488dd"
    sha256 cellar: :any_skip_relocation, ventura:        "172ace29b920a5b5efa15925666dce532ef4f1c4e4f71594d6e278c87f1a0bfa"
    sha256 cellar: :any_skip_relocation, monterey:       "74ba46931027180e85f2624dcc52039e502f2f882891b6c61fbe37d6b00e3cf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa52db6b9297d1117d6158bff2027873f5319cf0cecbcd3bb08d01444a32d83a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3e390c5294886b1bb4db6c98cb6eba5f2ba98fa63ce8e2fdcfba55e13a959ea"
  end

  # https://github.com/grafana/loki/issues/8399
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
