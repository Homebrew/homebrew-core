class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.4.1.tar.gz"
  sha256 "200ae8bb85f66be3c4b6064f30c06f295949b785e15d360d783538f626a193e1"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "11846c6d70e68c5e7f8adef102f614181f8df7b1aab70f48d7115c48569076ba"
    sha256 cellar: :any,                 big_sur:       "2900895ee36f13982baddb848990bb11a5bfc496910bf8741403f2cde63a2628"
    sha256 cellar: :any,                 catalina:      "687ac29e9c9b8b43fd9c278e4aa2d81e518d416aa23ea22179652abbb88f4836"
    sha256 cellar: :any,                 mojave:        "acc5956eb75c3a683e1bf11385686954dce46bc3e801cddefaa2342e4fdff7cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13db8abc441d8f11298ba99c611590d41b614eb20228fe3164c30cb99a203467"
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
