class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.23/htslib-1.23.tar.bz2"
  sha256 "63927199ef9cea03096345b95d96cb600ae10385248b2ef670b0496c2ab7e4cd"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a38faeceb5a5bbf1db94b8284866d39c26b4ff388553b475172bad7106594880"
    sha256 cellar: :any,                 arm64_sequoia: "ed6c17e8ed5f93267d4d83cb4c36feb8c26a650764490336ef522cf033b4dfc1"
    sha256 cellar: :any,                 arm64_sonoma:  "ec48464d019c3d8cb10c6af649c7ca5cb285052e82f2820ab592d94a1df378e3"
    sha256 cellar: :any,                 sonoma:        "55d83b5bd32a41299a86f559534f9d578261ac69ec057afd7236cee69ed5782a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6af2ea035e9e25fa70f14b88c00811c95199fb6055ab1a67272208a38f487ad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53cbf8e35c705d7df70ceeea2e93f2336d398be03777984f1c271f6c6776307c"
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
    assert_path_exists testpath/"sam.gz"

    system bin/"tabix", "-p", "sam", "sam.gz"
    assert_path_exists testpath/"sam.gz.tbi"
  end
end
