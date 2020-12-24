class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://sqlite.org/2020/sqlite-src-3340000.zip"
  version "3.34.0"
  sha256 "a5c2000ece56d2de13c474658b9cdba6b7f2608a4d711e245518ea02a2a2333e"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "286af27372fde1ea7ea8e0eb910a3707b622e73cfc1e66f23e7fbe4bf7d3d59c" => :catalina
    sha256 "99d4d1999862af18af2c16f3b80564e2202e3fbb17012283f0c9bdf87ef403b3" => :mojave
    sha256 "239bfe217ab89f4e6ef9fbfcc0f82996c3d5ab835324c3b91e42314e1cb002d3" => :high_sierra
  end

  def install
    pkgshare.install "tool/lempar.c"

    # patch the parser generator to look for the 'lempar.c' template file where we've installed it
    inreplace "tool/lemon.c", "lempar.c", "#{pkgshare}/lempar.c"

    system ENV.cc, "-o", "lemon", "tool/lemon.c"
    bin.install "lemon"

    pkgshare.install "test/lemon-test01.y"
    doc.install "doc/lemon.html"
  end

  test do
    system "#{bin}/lemon", "-d#{testpath}", "#{pkgshare}/lemon-test01.y"
    system ENV.cc, "lemon-test01.c"
    assert_match "tests pass", shell_output("./a.out")
  end
end
