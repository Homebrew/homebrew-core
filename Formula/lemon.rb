class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://sqlite.org/2021/sqlite-src-3340100.zip"
  version "3.34.1"
  sha256 "dddd237996b096dee8b37146c7a37a626a80306d6695103d2ec16ee3b852ff49"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f73ec9e5adc37f7ecf2dc5b0a05c2122cb51045a8fb7bca99a874c2b52beb9bd" => :big_sur
    sha256 "7d5d6b17c61c61039a78fc2ad90abde356053c75fc1ce24924845b03b9ab4f84" => :arm64_big_sur
    sha256 "cd970ac9a17164fd58a20ee54557dea07258e519b3a01654c00aca5db923d595" => :catalina
    sha256 "3723a266a33393454e89bc95eb86f643f4f6a6507a09fbc73bcd47fafb4adedd" => :mojave
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
