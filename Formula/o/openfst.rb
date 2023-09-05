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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "46eb8cddc071ee5bdf2df6cdb6f1891f2a0cffe8453cdc024970204866ea1918"
    sha256 cellar: :any,                 arm64_monterey: "ec9cdf817cbee846c502f05800db8d5106d558cd16afa935df22877ef71f98a5"
    sha256 cellar: :any,                 arm64_big_sur:  "277c268e760b1ea193494379b4e33e2c6d1ea0692be304f80363570dbf04aebf"
    sha256 cellar: :any,                 ventura:        "912fef9ae0e31f4c23e994250baa4e1434bd8aa6ee0d5f57baa2c8f587ce4705"
    sha256 cellar: :any,                 monterey:       "1f8a3f063ceef921bd4517956b4706897374f71b4a179bd118704688bd90e572"
    sha256 cellar: :any,                 big_sur:        "5d66b6cee648a6b9e29bf32b341fa57b0605d331e3a4acebb1f03fc3aa0373b3"
    sha256 cellar: :any,                 catalina:       "0cfbe1901bd76a5e5ec5fc5a30e9d902b91e70b7305dbc0ee3945ff5e23dde27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4eb7f68ee3bf2995d4ad13203bc4de0fc4b0c7b29a4e2ff5d884d73f969613b"
  end

  fails_with gcc: "5" # for C++17

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
