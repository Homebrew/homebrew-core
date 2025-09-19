class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.22.1/htslib-1.22.1.tar.bz2"
  sha256 "3dfa6eeb71db719907fe3ef7c72cb2ec9965b20b58036547c858c89b58c342f7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "300123c14ad2d7f7321292cf62df9dfb4d3e4cf03e3039eb25df7e12526ee0ab"
    sha256 cellar: :any,                 arm64_sequoia: "e76c369587ba4b585874efdaecd258eff6da7ac4aedb381f11037bbd7c7fa3e7"
    sha256 cellar: :any,                 arm64_sonoma:  "7daa278e05e29c59cda2dad052798784c853cc99fec3b33f7e37b729c8c072d5"
    sha256 cellar: :any,                 arm64_ventura: "007f00ae9c3a15bd7d6f818961af1c37d0fc2c24aab6f8d1d5398af474f0f1c8"
    sha256 cellar: :any,                 sonoma:        "450ff2011a21d8624602c0d0c55846889f8758bdb64dd729ae65bc53b376bbdb"
    sha256 cellar: :any,                 ventura:       "e94f546fd5ef891fbfec87da41293b3a328c62cf6a302a361362eba0cdd0cea2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00fa7e712cec3f4c66fe0d90405a4fcca972706b4925ed32a0b4fb02171a7f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdb6f258420f2e2a2f5dc7624e216186387c79358727a1734b39b0876edfc72f"
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
