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
    sha256 "a0289323819255885b7d45a89e2ebd88512f8153c1c956017258a61b07c29506" => :big_sur
    sha256 "b32fb6cb0eb43a7d8775d8bfc760c49471586eeb33797f3d44a8b53cd45dc792" => :catalina
    sha256 "7e5a450f383ddfeddcb7ee8d240e7db576fcc32a25c199d6a35eba40fea920d9" => :mojave
    sha256 "0635e790f390be0a97c78a434e723280339fe0f0d86ee55c4a34339840f160a7" => :high_sierra
  end

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
