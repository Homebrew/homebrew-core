class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.6.6.tar.gz"
  sha256 "2e353875557a0a09e2bf5e4c01f30175afd3e19bbf791e234731d32681c833ed"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "5999baa95e558d01847288277d0619c28cd8bf816916515fadad8a22502caa22" => :catalina
    sha256 "dea6e4114c2671797725de8415dcd97f5e2dd604ed8c65597a18ee33a96c9075" => :mojave
    sha256 "916b644ad413a1f68b47b6fe869b816f809967516744255840bdd84da079bc95" => :high_sierra
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
    assert_match "pspg-#{version.to_f}", shell_output("#{bin}/pspg --version")
  end
end
