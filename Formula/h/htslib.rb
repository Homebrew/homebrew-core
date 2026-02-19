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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "47588a34d25dc0536df24f4bc060bcff70d8a42222305e216547ce018d1c8cd8"
    sha256 cellar: :any,                 arm64_sequoia: "79d1fb81b378b58b97f491b004f4c0e7169c2a94e23258bac09ebc87170128d6"
    sha256 cellar: :any,                 arm64_sonoma:  "3875b123cc1dc1e2c34bdc7f85db4764b753718e8886b681c640354d0755896a"
    sha256 cellar: :any,                 sonoma:        "88b4bc1d39788edb7cead6d140357d67098a24fdde0d8eac503085218ef59f60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9dec45c4d70d148f6c36841697520a39ddc56b6648f10bbcc692399b7a0aa16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e5135181a4e4a25dfbe64e1084c4e0ce0603f37d645a01aabd849fc267aeb89"
  end

  depends_on "libdeflate"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
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
