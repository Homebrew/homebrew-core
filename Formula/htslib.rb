class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.15/htslib-1.15.tar.bz2"
  sha256 "1a9f49911503a22f56817cc82ea9b87fb7e7467b5ff989ca5aa61c12e7d532d9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "75ad52abf7902d356ecd260cdc922220879284462d3178194e14e57b87b21cdd"
    sha256 cellar: :any,                 arm64_big_sur:  "01178faca1c4825644c4f45d719c547d97eea893ece6eaff9aba9ba3e06155c3"
    sha256 cellar: :any,                 monterey:       "fdd1fb62df77a796745eb09f9b348c78176703f4deeb593a8f881845c4b426d5"
    sha256 cellar: :any,                 big_sur:        "cf7d3aa06fb89dca0f35f9184d2f431897fc290ed20b90c838cea235c4de814c"
    sha256 cellar: :any,                 catalina:       "89e858252df0b8fec7e07dc82159bb4a9cb629ff54eb5848b319baef41197e26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90d770d787efcc137b83a491385683949861a0c5a9084e8eae66ff4ff47ce432"
  end

  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

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
