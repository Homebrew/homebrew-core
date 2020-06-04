class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v1.1.1.tar.gz"
  sha256 "b136727d0ed114ab18d9d380e1ff70ad70e60b56bbacf854be2aeddc9b20044a"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ad4b9f51511af180210f5b90fb3f8eb127a0448357a0a4f2c315f217430c3c4" => :catalina
    sha256 "4c9604e030fee6129c830631328efafddb2237658b35215a8cfa471207385cd0" => :mojave
    sha256 "6149a7dd742bf02f4f38e4b43837ed7a9de7781f810d0d460b1e0884c537fe4f" => :high_sierra
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

    system("#{bin}/gauge install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system("#{bin}/gauge config check_updates false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
