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
    sha256 cellar: :any, arm64_big_sur: "7df497b0d0ffc8370403fb973ebd143e8c2776978f7f6aaeed045e1ff17c3121"
    sha256 cellar: :any, big_sur:       "337d53e97fef7ccad36110c39283f261d377442573182743ac892fa6bf2e0ed5"
    sha256 cellar: :any, catalina:      "884b19991c4f1ac91b4ece1979a1585947283dc8eaa2ac12275b8e44e14d4e4b"
    sha256 cellar: :any, mojave:        "1c65a9f4187196a2bc689a5a0299e7b9eafd0a192ca1b0e6ae924a9d13e8974b"
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
