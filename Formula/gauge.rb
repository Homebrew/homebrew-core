class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.1.4.tar.gz"
  sha256 "9250fde749c51b76acd375a82e27fbed758ff8982d9e6dc82c70e4dc218e6b4a"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ca44657fe21bc455ba45eb4bfcfb0ca357fbab7521aad838e8bfc5322dbec52" => :catalina
    sha256 "68c53219038d4a306f6ad514ac5452a348259973e9a53f74e526f48deedbc62a" => :mojave
    sha256 "78f792b17d8d9d71b9ce38754c0584df583e87b3a23b3a13139ba345505dcd35" => :high_sierra
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
