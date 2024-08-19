class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.20/htslib-1.20.tar.bz2"
  sha256 "e52d95b14da68e0cfd7d27faf56fef2f88c2eaf32a2be51c72e146e3aa928544"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b57cfe11502c0d4b8d7d87b3e100b864c6d54919a13afe771003cd1c5ab4e7fd"
    sha256 cellar: :any,                 arm64_ventura:  "e8bdefab6c3c5f268b3de351bee60d4219d3106ba9495b045c300299bed15340"
    sha256 cellar: :any,                 arm64_monterey: "d0117119343a7fd14531db96d2c0d82cefd00156e2addbf4582959713121fc4f"
    sha256 cellar: :any,                 sonoma:         "34e920bc28bf678c6ede59714a35aea4644fb6feccc4a0e2e830d2a74ceb0007"
    sha256 cellar: :any,                 ventura:        "aeca2fb129525817e5bd00b8a32f5fc8f9841f963358b00ed01c8ec56d647bcf"
    sha256 cellar: :any,                 monterey:       "a35e2728e23394a7b0c4764fa3ded2bc23b29d2505f31183c3f965011d81d1a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2d11ad1fe3539918fae0b520615aaa2737816cfeb606e1160d2776b86a781ee"
  end

  depends_on "libdeflate"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-libcurl", "--with-libdeflate"
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

    system bin/"tabix", "-p", "sam", "sam.gz"
    assert_predicate testpath/"sam.gz.tbi", :exist?
  end
end
