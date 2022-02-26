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
    sha256 cellar: :any,                 arm64_monterey: "00b69cc66e87c59ef293d8cca638ceaf28395a0d706e3bac49ccbe92eb50d220"
    sha256 cellar: :any,                 arm64_big_sur:  "08054416c27ceac3a94535b55d9b8b4da5f7e3ff1ad41266a7e100664692a41a"
    sha256 cellar: :any,                 monterey:       "bfd4c6b71e3a664e536db985972ccb9544bab352e4d54009f46ad5e2b453eee6"
    sha256 cellar: :any,                 big_sur:        "c0cef5da5c0db60ff7d4af32bf555d4f866373a2ca3f193cc2905599f343a187"
    sha256 cellar: :any,                 catalina:       "7a9ae55bc8c586f38af32238e0c785aba75f62ba628b3e33664b2188e4625814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9db11dfb037c3801bcf9ef57ee4194b15952a898b93222554aa52a29229f080a"
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
