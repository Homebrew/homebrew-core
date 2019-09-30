class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.1.2.tar.gz"
  sha256 "6209732de97a843e9c0a1de99307927fa54203d19e0b9be4dbebc63449090ea9"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "9135882d539c94520b999e8f7f1d34bbcbb938f95f11b2e3ca4dac52fbb888df" => :mojave
    sha256 "2ea8ab2c662ba3da129431912dbdbe57b68b698107477c6d17a333662445a993" => :high_sierra
    sha256 "a2697cf16b13c7623af2c3c54c8c7f61d8f9e8585e801b51076e555080c8921c" => :sierra
  end

  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
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
