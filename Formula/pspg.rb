class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.5.3.tar.gz"
  sha256 "c5360f42af5f87f07c8cb894b2da622685d1d800022cf9d22bfa37f3f918447b"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f4c0dd8da5296900184b512e00ae6111c8cfa0bf34717c80cfa3e45b1f54afd8"
    sha256 cellar: :any,                 arm64_big_sur:  "df23b53135092f3e1f244279928f6aabe74613e03043df43e7c6a4bd04c2b02d"
    sha256 cellar: :any,                 monterey:       "fb1031c34f418e2616216bf4d9cdbc416d4efe3e32a81bfda52769ffaf114b49"
    sha256 cellar: :any,                 big_sur:        "194fcc895333db39d65dc3ce9d1bfe1a148a72c5ec194fd971f9638068ceb174"
    sha256 cellar: :any,                 catalina:       "ae02a90ac1ea7d3a88c41e5994e2739461ef425a6962dc07444a9d391d081f56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1cc8f081229089d49369574531d2f8aaf695c1c7510fb5b414be9e61fc67ea3"
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
