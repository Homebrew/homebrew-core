class Openfst < Formula
  desc "Library for weighted finite-state transducers"
  homepage "http://www.openfst.org/twiki/bin/view/FST/WebHome"
  url "http://openfst.org/twiki/pub/FST/FstDownload/openfst-1.8.0.tar.gz"
  sha256 "9730f1934f60f1320e46af44826e954bc6f7a695946548005ac33c1821745440"
  license "Apache-2.0"

  livecheck do
    url "http://www.openfst.org/twiki/bin/view/FST/FstDownload"
    regex(/href=.*?openfst[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "5fd5b3e6e1cab084de39129ee2a5ac9512a45bf564029682598bea2c4fd83aed" => :big_sur
    sha256 "520a3a1fe07f55b4d12de03cc259b19e12152f3e02b7991abb8512c6d94208bb" => :catalina
    sha256 "ab87b1086002ff7ce0174cf9fc6e6336960b4e23c890ac9a0572ccc44e5cda5c" => :mojave
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fsts",
                          "--enable-compress",
                          "--enable-grm",
                          "--enable-special"
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
