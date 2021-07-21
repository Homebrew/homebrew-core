class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.1.2.tar.gz"
  sha256 "3d2491ec3bf8fab3ec99ddef7b783688f76c274bc26395aa3cc7204b75c0870c"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c09b384c16e0ade7d4353d1b6d06cc61ab22b06004722dfa9ab7adb8e1d583a1"
    sha256 cellar: :any,                 big_sur:       "2e3bedf6ad2407132c8107dd3f6adeb6196434c1b9c7ca6f6234e986c8ffd433"
    sha256 cellar: :any,                 catalina:      "5453a259da8c58a1649abe3cb76e8eb7f6e83300905df47ff0635b23538e4d85"
    sha256 cellar: :any,                 mojave:        "3665fda66d39b6424b14b59d4d691ecbfab1595ec17b8b1cd1fa8cb18ab7efd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b665862f542d0cacb880e34483f8709bae7689ba2832cc08f13f5b6de51d1edf"
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end
