class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.17/htslib-1.17.tar.bz2"
  sha256 "763779288c40f07646ec7ad98b96c378c739171d162ad98398868783b721839f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4a8afd89ce022fa5b96d48eccf722b5c2de89fc3d5a4647e008f258213abdd69"
    sha256 cellar: :any,                 arm64_monterey: "7df3e7e8726cb0408012e163bf9def4f35092d93dacbdd5313ce8de1538ab94e"
    sha256 cellar: :any,                 arm64_big_sur:  "4646c094d0f879d4306cb81fb41e75e02ba0f8aa6d39ef39e888b72a479e522a"
    sha256 cellar: :any,                 ventura:        "34394201d6fe82a39acfb138066915df1bdc3a556771f3db4e899bb1e090e7a8"
    sha256 cellar: :any,                 monterey:       "72a3c2f33257d4d61457e01432069fba29f69778c3c6959b1284e07f079d1e81"
    sha256 cellar: :any,                 big_sur:        "f83414d88cef9dcd8c4192783c1db09aba41f6b823ac3dfc68ffbccc564e5d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb839de87a255d78f48d38121f6b14558146e45f50725e9fd2a96010fc170f8b"
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
