class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.2.1.tar.gz"
  sha256 "4a3fc07a8252fc8457827131302a6a67ae1308b405838d35b31cd43864d4c947"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1123270c3838ef1f570a457dd1a3ded3a9cdefe03ca02601424e5e58fc9535da"
    sha256 cellar: :any_skip_relocation, big_sur:       "79c82b9f1054f26dda172029f47a9027ff16b8475e0b30e562a41fab95a35df7"
    sha256 cellar: :any_skip_relocation, catalina:      "29cc3a16f5fa152649d4fd7d5ea971866783138cfea3d46474409fb8e677e9ed"
    sha256 cellar: :any_skip_relocation, mojave:        "329f36c29dc4f2689663c5ecee7f5778c2b7d759411f4c315301e6b9e8b9448a"
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
