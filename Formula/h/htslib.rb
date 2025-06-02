class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.22/htslib-1.22.tar.bz2"
  sha256 "6250c1df297db477516e60ac8df45ed75a652d1f25b0f37f12f5b17269eafde9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3f2f3384d807cf96d55f5d9ee31b073b289fb4c64ba9a11f8fb3242d8dc1858e"
    sha256 cellar: :any,                 arm64_sonoma:  "3c77b5d9fd49d47b2b564b8ee27fc49e9edd26823acd90f9404e20a9e2475fe8"
    sha256 cellar: :any,                 arm64_ventura: "75e8ee504a3eab812f7d89466eae548555326d402cb88fdb5ba055795b903926"
    sha256 cellar: :any,                 sonoma:        "e01127e06e3b038b2b369282b0eea80e150ddd9af5ad19425acdbe41656df073"
    sha256 cellar: :any,                 ventura:       "11d618732f21f25791476ded2decbde94109ec1a40eb790f49936f825b07f4d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fc3eb865aaa8f8c3d586cb7dcc70b46178a5e16e6a5a68d6b1af8f7ada4974e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b91e2b3ea97ac6210260a78519720b6b560cd8c4f86761d75ec72d8fbe312f55"
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
