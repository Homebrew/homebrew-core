class Molden < Formula
  desc "Pre- and post-processing of molecular and electronic structure"
  homepage "http://www.cmbi.ru.nl/molden/"
  url "ftp://ftp.cmbi.ru.nl/pub/molgraph/molden/molden5.7.tar.gz"
  sha256 "5e7b3a8bf9251626d362b1d1dd8e4362054e6bce505c43e10254265857bb6e7d"
  revision 1

  depends_on :fortran
  depends_on :x11

  def install
    system "make"
    bin.install "molden", "gmolden"
  end

  test do
    (testpath/"test").write "title\nfile=H2O.xyz wrxyz=1"
    (testpath/"H2O.xyz").write "3\n\nO 0 0 0\nH 0 0.76 0.47\nH 0 0.76 0.47\n"
    system "#{bin}/molden", "test"
    assert_predicate testpath/"mol.xyz", :exist?
  end
end
