class Openfst < Formula
  desc "Library for weighted finite-state transducers"
  homepage "https://www.openfst.org/twiki/bin/view/FST/WebHome"
  url "https://openfst.org/twiki/pub/FST/FstDownload/openfst-1.8.3.tar.gz"
  sha256 "077714159d5cf3e38a80b6c6656d3ccc2c8b8b6c50bb41bb65c5fec10796bf53"
  license "Apache-2.0"

  livecheck do
    url "https://www.openfst.org/twiki/bin/view/FST/FstDownload"
    regex(/href=.*?openfst[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5d174e442429bca62cb5efef625032721a5c6987e18ade3078e88091df31d921"
    sha256 cellar: :any,                 arm64_sonoma:   "3a0436dfb645f06b824d626e1b8e10c47b782b7134c6ac04d5f4ee4df106db22"
    sha256 cellar: :any,                 arm64_ventura:  "76a0f9e9075766f227495fe513ce756167b62d3c6fd326399bbe259ba493b6ee"
    sha256 cellar: :any,                 arm64_monterey: "45aa8f4f880ea7e84b9aa4463f892d25b41b00cfb684aeb81efa94088e18d4c2"
    sha256 cellar: :any,                 sonoma:         "9cc3657fddcd253c2e69e870a90978776f0356fab021338dcaad3c4c2837c20e"
    sha256 cellar: :any,                 ventura:        "918bf970528321b4b385c8e08f57d9a45b530428bac2b0e74a474e5434fa1f03"
    sha256 cellar: :any,                 monterey:       "62b9fbfe4dd8e058825ae75a682f922844c4f3dae90d956e5e9e0192496d33ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18b293aa36b18f6c227da97b39f8389accdf0f02a6b5801b197d062a473407fa"
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
