class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.6.1.tar.gz"
  sha256 "4b41175e552dd198bb9cae213df3c0d9ca8cacd0b673f79d26419cea7cfb2df7"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3882ad0907a93b3c78bb7473cbc9a695c60bda82179bcc181e25bc300b97c1a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4b16da47a7162c154f242444663ac2d87cdb7f04ba9fba70a30273784f90939"
    sha256 cellar: :any_skip_relocation, monterey:       "a672473b537e1ff5013af85e251befd0b4f9e247b797a1dacf6587328d5d2752"
    sha256 cellar: :any_skip_relocation, big_sur:        "10f1f7b6f129999e32f7b0464c5527dab25d25c429ed4ff2aadcd7c3589c111a"
    sha256 cellar: :any_skip_relocation, catalina:       "905635ea6c008b0d64584550b4f13f1e44c673f62e7e4e203b0aff203e112b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c745400ce81042f0445ff608af40939b2207ecc0c8ae78b33f3d845d4f5c128"
  end

  # Required latest https://pkg.go.dev/go4.org/unsafe/assume-no-moving-gc
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build
  depends_on "loki" => :test

  resource "testdata" do
    url "https://raw.githubusercontent.com/grafana/loki/f5fd029660034d31833ff1d2620bb82d1c1618af/cmd/loki/loki-local-config.yaml"
    sha256 "27db56559262963688b6b1bf582c4dc76f82faf1fa5739dcf61a8a52425b7198"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/logcli"
  end

  test do
    port = free_port

    testpath.install resource("testdata")
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! "/tmp", testpath
    end

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    assert_empty shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
  end
end
