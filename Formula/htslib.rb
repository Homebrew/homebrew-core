class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.13/htslib-1.13.tar.bz2"
  sha256 "f2407df9f97f0bb6b07656579e41a1ca5100464067b6b21bf962a2ea4b0efd65"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0f84a4bab64db1ae6333e415bbcba48ef8c659fd3e94182a4cfc4baf2e85d9e7"
    sha256 cellar: :any,                 big_sur:       "1c18fea212fa8c79639aa73283277a9f38451d8c27b63942ae1d27082f86a712"
    sha256 cellar: :any,                 catalina:      "f063c7ecbbace5ca9c5110ace1e45ad3629323108bfbd77b3d0cdfbeca7979c5"
    sha256 cellar: :any,                 mojave:        "291e64099d31bffc8c3151e28702e611a5adf83d47aa123a53a4149a3374ad3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38e217917f15baa38f80d718e658b04786c648904a2293a19042489c630deb6a"
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
