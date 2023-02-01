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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd2e7de171a2660b583b183a10a76c4b8d6b623e78daad8ce7b773f1eb952ea5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01c9519bead8c4424071efd56536ae260fbd1d243a200175bbf4daf22055f70c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08b8acfc894cace093bcc194d75fdd5069a94e99030ec72e83ffd269fe277c82"
    sha256 cellar: :any_skip_relocation, ventura:        "dca8890d5e5c29a6aed99b84c9083dd7374d2489ad41577c08d89565a2e4f2ef"
    sha256 cellar: :any_skip_relocation, monterey:       "2bfa3bc5acdf2278050fcbed5b8b033a6b93859041e0bb6eb2c8861c1f9df6c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "967fabad07cc9a68fe53c3ef32db461cd4b92fe43732f7a66ae107b65fd212a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa60928b398411ecdc72646d6b618aafbbc647c1cca75ee48700602959feee19"
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
