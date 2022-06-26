class Openfst < Formula
  desc "Library for weighted finite-state transducers"
  homepage "https://www.openfst.org/twiki/bin/view/FST/WebHome"
  url "https://openfst.org/twiki/pub/FST/FstDownload/openfst-1.8.2.tar.gz"
  sha256 "de987bf3624721c5d5ba321af95751898e4f4bb41c8a36e2d64f0627656d8b42"
  license "Apache-2.0"

  livecheck do
    url "https://www.openfst.org/twiki/bin/view/FST/FstDownload"
    regex(/href=.*?openfst[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9c205f655815ece696db66cb6d951bc421187a7d5e564a5c9c147d5077ba7dba"
    sha256 cellar: :any,                 arm64_big_sur:  "677eca1e0c86c76cf78a05d193074065e96bd121b3000f5636e596d211ce4ad8"
    sha256 cellar: :any,                 monterey:       "35b01a7251c02f16c451a8dd961c3461bae8715289bb529f6580aaee90b0defd"
    sha256 cellar: :any,                 big_sur:        "61788460f5d24b7feb792e36158722880048512a56b67bd93a185c613944471b"
    sha256 cellar: :any,                 catalina:       "7a279be4687687d2aba95247292e72e9b51cdad00343478069f56d72360fde1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d09e40d67f808e45549c67a15b4f8beca5e13dac9c30603411c3095ad07fa4e8"
  end

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

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
