class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.23.1/htslib-1.23.1.tar.bz2"
  sha256 "f8a3f36effeec38f043c53ab1f2d9ed45064f14205c5ef8e3c815763b90803c4"
  license all_of: ["MIT", "BSD-3-Clause"]
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a0d00e5fbe31dac3e1994e07ed57175acee4d32ad0d88180c89d1f1e966904e"
    sha256 cellar: :any,                 arm64_sequoia: "f627661b1ec0bac1225e8e179eb583ca214b63fab33ca3bfe4b8646ea8af8e17"
    sha256 cellar: :any,                 arm64_sonoma:  "cdccdb46501db095f4a746e4681714f9e2a11d40980a4cfeaf332f94c7eb56d8"
    sha256 cellar: :any,                 sonoma:        "a3f478876c6ebefe567c32b2c15678984ec63621dc12f66fe30fa12806929315"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3b36bac7e8c6084eb5d6ab9a01feab6a2bfd4fa7b247791df59e12866092ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "831d616b08a81740389afb6b710dfff4e6a1d012a395e2c69b47341a5958e4c6"
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
    system "./configure", "--enable-libcurl", "--with-libdeflate", *std_configure_args
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
