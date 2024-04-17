class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.20/htslib-1.20.tar.bz2"
  sha256 "e52d95b14da68e0cfd7d27faf56fef2f88c2eaf32a2be51c72e146e3aa928544"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9fbfe8953941d6c1b121672e533c0f677dc817f0c49aef72ee2ada50c8ee2c98"
    sha256 cellar: :any,                 arm64_ventura:  "26b3ea2b0217b1995069eb1109d2ec77a9792cd310625f066412f2b6147c8016"
    sha256 cellar: :any,                 arm64_monterey: "243aa954fa86249f2c4b0223b331949ad856f26a6fe31508d5a88299990a9d47"
    sha256 cellar: :any,                 sonoma:         "8c3c97d6bb1b1dddf675fa75ec4f6a8f27144acd65575307e96da5dc20163b7b"
    sha256 cellar: :any,                 ventura:        "bbba88c048749552415a7f9d7251195a7a4f5dee7ec20327ec99995b07babb27"
    sha256 cellar: :any,                 monterey:       "1983bc40811162d756e7889d84ab1b16997c1e575404efed0c3bd7eb2ffe712b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e5690f88f816c9291f96558338954b4dd27edb166b32cedb5edcf49c3034c95"
  end

  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

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
