class Openfst < Formula
  desc "Library for weighted finite-state transducers"
  homepage "http://www.openfst.org/twiki/bin/view/FST/WebHome"
  url "http://openfst.org/twiki/pub/FST/FstDownload/openfst-1.7.9.tar.gz"
  sha256 "9319aeb31d1e2950ae25449884e255cc2bc9dfaf987f601590763e61a10fbdde"
  license "Apache-2.0"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"text.fst").write <<~EOS
      0 1 a x .5
      0 1 b y 1.5
      1 2 c z 2.5
      2 3.5
    EOS

    (testpath/"isyms.txt").write <<~EOS
      <eps> 0
      a 1
      b 2
      c 3
    EOS

    (testpath/"osyms.txt").write <<~EOS
      <eps> 0
      x 1
      y 2
      z 3
    EOS

    system bin/"fstcompile", "--isymbols=isyms.txt", "--osymbols=osyms.txt", "text.fst", "binary.fst"
    assert_predicate testpath/"binary.fst", :exist?
  end
end
