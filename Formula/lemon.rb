class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://sqlite.org/2021/sqlite-src-3350500.zip"
  version "3.35.5"
  sha256 "f4beeca5595c33ab5031a920d9c9fd65fe693bad2b16320c3a6a6950e66d3b11"
  license "blessing"

  livecheck do
    url "https://sqlite.org/index.html"
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7027ff601090217b6c1378d47580b41b8111f0d66d646bdfbfcc430ff3ad0f0a"
    sha256 cellar: :any_skip_relocation, big_sur:       "68fb9d794706f072174d9efa3cf603f7151bf4472d227ab94c247d855759e9ce"
    sha256 cellar: :any_skip_relocation, catalina:      "8376c00bf91370667128f720bb8ae5a8bd9756ca057145ae8a1e12d00799f964"
    sha256 cellar: :any_skip_relocation, mojave:        "53ae7fd5849d6058ead9e06b09a6dd2f1efdbf0886f7741391e11955ba7fd423"
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
