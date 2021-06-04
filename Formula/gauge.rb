class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.2.1.tar.gz"
  sha256 "4a3fc07a8252fc8457827131302a6a67ae1308b405838d35b31cd43864d4c947"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "43a9f3609c07ead13d8796150822823b581232df077b0348806ed314d4e9d78c"
    sha256 cellar: :any_skip_relocation, big_sur:       "40fdf987c03683e24eb643fb2c822e976bebb38c71c280cd106bd2142168265d"
    sha256 cellar: :any_skip_relocation, catalina:      "fd296bdc448217725fac72ef38e688fbf67ca0a6cca3300313cdc55800563029"
    sha256 cellar: :any_skip_relocation, mojave:        "93422569fd4ae31b8eb9d4a568f45758bb9eff0f3f36c82082b249608a26a0aa"
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
