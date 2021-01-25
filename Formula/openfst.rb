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
    rebuild 1
    sha256 "44287522a924816ee4c94f9b2e5e2c88caf0033e1b939ec6f21bd597fc8abfdb" => :big_sur
    sha256 "683c64892ce67d682098c5f4fd6969c15f98af009ccd61331489b3c9c040d8a4" => :arm64_big_sur
    sha256 "b49da4e3ff869f532bb920a61523f65f131e5fbfe4de034a4422664ca10bb92e" => :catalina
    sha256 "06cd8774b212aca225964d495f1627dd8e4bc4b58b7d527f9b32bc3a974c69e6" => :mojave
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
