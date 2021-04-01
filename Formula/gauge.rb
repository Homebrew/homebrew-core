class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.1.8.tar.gz"
  sha256 "3f2ad1c4684083f9f4eaa468dd56c066d888c132ae9f64a84e2cb2f9d7f88527"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "15b565e94faaca48f9b77f91fdbfd09356e1fe1d4ecc994bf4771b69775f6970"
    sha256 cellar: :any_skip_relocation, big_sur:       "9776a8cfa2ce861028e4b359a4e1ece0efed04c3645388dc584398f031740c49"
    sha256 cellar: :any_skip_relocation, catalina:      "709193f4a31a5e065c922d4873e3dd89087f6eb23f2ac06e1c2a1ee91cc44131"
    sha256 cellar: :any_skip_relocation, mojave:        "5d853d4361569132df6f4f10ccfc124cda557b8ff4fa061743430f844268dcdd"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}/gauge", "install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system("#{bin}/gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
