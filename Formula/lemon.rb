class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  # FIXME: Add this back to `synced_versions_formula.json` when
  #        this is updated to 3.37.0.
  url "https://www.sqlite.org/2021/sqlite-src-3360000.zip"
  version "3.36.0"
  sha256 "25a3b9d08066b3a9003f06a96b2a8d1348994c29cc912535401154501d875324"
  license "blessing"

  livecheck do
    formula "sqlite"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2bbe4a5b574c3bc162a9e9ef5073f642c89930bd0b81f1ae7bb78463d6491aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acad2c45ba75ce33323c6cf4558dae1872faa88ee4fe76bd07ceb4a2be5824aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9895753eefde9fd60263be373f014f1cb77bbd4065ff1c2c6fca12450bbc138"
    sha256 cellar: :any_skip_relocation, ventura:        "c4922851d6002649701c324500e665be56fba4aaafe8d7a4213fc3b0fef5bc57"
    sha256 cellar: :any_skip_relocation, monterey:       "e929cd9b9c077996bd94dedd99f750d66dc84d25603114de7189d490e125de2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6b34bdbe078fb14319d9ece2baf5e8525755681b0746533614beae982c60c47"
    sha256 cellar: :any_skip_relocation, catalina:       "33b24b43065b09972b1920ef895cea10367a24c62d868fec55fefc77b87cf5c9"
    sha256 cellar: :any_skip_relocation, mojave:         "02cb0c5dfe67351858960a11708173a226d62e4085635a692b41525607ab1454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29561eac80c7a860cde7c8ec83241778ce0f73fed5056e27eb477a3695c810af"
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
