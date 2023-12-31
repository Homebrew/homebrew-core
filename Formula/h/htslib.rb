class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.19/htslib-1.19.tar.bz2"
  sha256 "8751c40c4fa7d1f23a6864c5b20a73744f8be68239535ae7729c5f7d394d0736"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "982ab2bf759b8878e188688b22421dd4de1f7bc995d402c461ac161211734766"
    sha256 cellar: :any,                 arm64_ventura:  "826ce467710f3bbd57d256836430c48d23c8bb6120e9067e494bea57ca314a6c"
    sha256 cellar: :any,                 arm64_monterey: "ac1471477d8a2dd9226197c61fa10dc753b6a639d230421c24a3724d81ceeb85"
    sha256 cellar: :any,                 sonoma:         "95f168603ab1b796bdfc2ea287eb9e69d757304acf18047d49799e647b05b686"
    sha256 cellar: :any,                 ventura:        "417fe0b33ae1c9d29c98485a448a0766ec60e8521a7b1bd31a39ea75ed3a2e1e"
    sha256 cellar: :any,                 monterey:       "a818cffb51e30fec9a02c17a7a23dd24cb7bb51caff4d7ee6cbafdee3dd695c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8348999621fffe485c02cc53426163373cbe5b7f6bf52c9cc05d015702938759"
  end

  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-libcurl"
    system "make", "install"
  end

  test do
    sam = testpath/"test.sam"
    sam.write <<~EOS
      @SQ	SN:chr1	LN:500
      r1	0	chr1	100	0	4M	*	0	0	ATGC	ABCD
      r2	0	chr1	200	0	4M	*	0	0	AATT	EFGH
    EOS
    assert_match "SAM", shell_output("#{bin}/htsfile #{sam}")
    system "#{bin}/bgzip -c #{sam} > sam.gz"
    assert_predicate testpath/"sam.gz", :exist?
    system "#{bin}/tabix", "-p", "sam", "sam.gz"
    assert_predicate testpath/"sam.gz.tbi", :exist?
  end
end
