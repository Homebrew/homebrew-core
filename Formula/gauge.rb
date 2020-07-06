class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.1.1.tar.gz"
  sha256 "b136727d0ed114ab18d9d380e1ff70ad70e60b56bbacf854be2aeddc9b20044a"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "31440544842f79e972bf2df49fc4f87f4ee843f67fab0c007687ec6eac38f2cb" => :catalina
    sha256 "590ec7a1a946660cbcab4a202666ac49c1d8cb43f791193a54760a8378c14189" => :mojave
    sha256 "503c38cb1eeeedfbd24250e202107d64fc6712e40095b55880cb5893d04911fb" => :high_sierra
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
