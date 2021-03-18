class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.12/htslib-1.12.tar.bz2"
  sha256 "2280141b46e953ba4ae01b98335a84f8e6ccbdb6d5cdbab7f70ee4f7e3b6f4ca"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "064702cff6bf08fcde27f3315ee3f252d4ab402cec419165bc9c3a29b0ff88f1"
    sha256 cellar: :any, big_sur:       "041b57665a510b5f997378bf3e3ce77c514dd3d926bb657b8ed51c5d3d12428d"
    sha256 cellar: :any, catalina:      "f28d03e151afa13f70ed32382fe39dfbd519b94684bffc1351e38c928156f678"
    sha256 cellar: :any, mojave:        "e32ece4437430fb982ab295b6efaa9bed569dd5a661adcf1bc4240b48ae72914"
    sha256 cellar: :any, high_sierra:   "b0fd73dc104edc3fc591a998ce27fe99e8086873b0ac29775532374213225a1f"
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
