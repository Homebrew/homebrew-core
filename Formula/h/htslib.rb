class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.19.1/htslib-1.19.1.tar.bz2"
  sha256 "222d74d3574fb67b158c6988c980eeaaba8a0656f5e4ffb76b5fa57f035933ec"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6733ceb8d7c9c4512bbd3ec267a846d71489cd638b5e0a8ce1650c8e2ff5505e"
    sha256 cellar: :any,                 arm64_ventura:  "0d35d92009b48f4f60d7db899d37f14f1cce781c93ca279df822f61f81709a20"
    sha256 cellar: :any,                 arm64_monterey: "2bbb4f2eabe5bb0a2eaec819ebe9947690b368b9e8160e5ac7f0042a363ec35b"
    sha256 cellar: :any,                 sonoma:         "9c37fd9a563cf1b5a09e377efb3c9c43d15ee56c0c70688745e1177f0dd1cef3"
    sha256 cellar: :any,                 ventura:        "58e74d9d0b90ef4da884a59f5aa808056e285f4dabd97fef6f134fb224ba6b42"
    sha256 cellar: :any,                 monterey:       "87311767ab21be3a49eaa066e88d0534523e018b1e31988600e55e1f3aa4a509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f770fd413989e4cc735e5c1c1ec60fc8122cb8221fb62045d524354feb5f76fe"
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
