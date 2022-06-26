class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.15.1/htslib-1.15.1.tar.bz2"
  sha256 "8d7f8bf9658226942eeab70af2a22aca618577eaa8fe2ed9416ee306d5351aa1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "126ee5017717e388750cafbea6b2915b5550c9be5f5623798e173e3ed35d91e5"
    sha256 cellar: :any,                 arm64_big_sur:  "6ffc3560ccf65563420b32c35177b738783fc5b7499c2e16efdf6f2157264497"
    sha256 cellar: :any,                 monterey:       "51952a370f820e68811bd9c891c2f134eb0366f751acf5f23e665ee2b2b15a65"
    sha256 cellar: :any,                 big_sur:        "ea69b2d7b0f29325dda506c73a8cd726fac704397d2d991422660b0f56f13f53"
    sha256 cellar: :any,                 catalina:       "fad753cd51694302972903cf8b4a8655aa5a76014a7a1ed272ec611ab1791da0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4888416ae72370da97c251d870fbc5e88f53b3abdf262ff73779b9095b55a365"
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
