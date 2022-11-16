class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.16/htslib-1.16.tar.bz2"
  sha256 "606b7c7aff73734cf033ecd156f40529fa5792f54524952a28938ca0890d7924"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "eacb91f61003001f6517121793e7bceb98c20634053b27bcd162dfabd3023bc9"
    sha256 cellar: :any,                 arm64_monterey: "aa04c43c00b9334233a3a696b5f4aef768f751ff822d5260cc984c514771479d"
    sha256 cellar: :any,                 arm64_big_sur:  "521f1a883ef338cbed57d4f229ef7c7c1ce14d8e05e289e2fb5906c4d900bcc2"
    sha256 cellar: :any,                 ventura:        "5e3b6670df6fbdd79e38fa60b88dd51bfb3e3cd1569933de24a94b3c92c183d1"
    sha256 cellar: :any,                 monterey:       "ee3572c2f0fbafe3cb1692de2742adb6316a3fe765660b61af425055980f8bc8"
    sha256 cellar: :any,                 big_sur:        "0e3a99fb0f0946b8f9d08b1eaec32b3501cc462fee89568b9ce05184e83f42db"
    sha256 cellar: :any,                 catalina:       "2aef4311f74d3991b2f6830197d08027b5837da86f36f0fff28afbffc5f026e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22d79594ce6ad700cf122f5574edc5e624d31392ad727a8797b484797f955186"
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
