class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.17/htslib-1.17.tar.bz2"
  sha256 "763779288c40f07646ec7ad98b96c378c739171d162ad98398868783b721839f"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d7848a7937ef7f417911e5b0c11a9317de1597aea317912a34a45f19319d2edc"
    sha256 cellar: :any,                 arm64_monterey: "98a7488f931681e9df965d1e55ea72b834e40b460a64648d90bc3f5324cd7cbf"
    sha256 cellar: :any,                 arm64_big_sur:  "e8bf594d1b9f6f3f26e2a80d13866a88d11eb66dbba01081ad6b9e9d90d17895"
    sha256 cellar: :any,                 ventura:        "55ec940236a95fed446ee41f05e926e9e4af7626b85378a15b8631ecca091d62"
    sha256 cellar: :any,                 monterey:       "9c6ab8c15fa6cf1ee526490ad3ab831c5a809f47db60e60f7f8d5e3a27bc9324"
    sha256 cellar: :any,                 big_sur:        "396446a87d57877f76513c41678513d48629503050c6bebeda58b539d33712d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eeb51a686f7eac767e4d49a4a1b175c602c7eb575f214553637517d25b5773c"
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
