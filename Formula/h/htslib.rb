class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.21/htslib-1.21.tar.bz2"
  sha256 "84b510e735f4963641f26fd88c8abdee81ff4cb62168310ae716636aac0f1823"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5666590893b28330ba567928e6c9a3f9df35f31bbe1141715f598943ea2792ac"
    sha256 cellar: :any,                 arm64_sonoma:   "13cfebf52afda554d0356c9c15fadaf0361a13b63354f6fd6408070cc2189dc2"
    sha256 cellar: :any,                 arm64_ventura:  "140f35781a6dca49898ee9b16cd8d9566b67147508604da63b1dc614cf4acad9"
    sha256 cellar: :any,                 arm64_monterey: "6631954131f70ee19111f4c9f1c7920995333638a66959714d63bb81effdd07f"
    sha256 cellar: :any,                 sonoma:         "9242245655ac588d50e779950bd07525c5a5ffa3fd84531d837336c67dd5c85c"
    sha256 cellar: :any,                 ventura:        "5fb7968f1ee7824d0c42550ba6441559f3d2d61ded9b838fbc9e4681f8b9a0e7"
    sha256 cellar: :any,                 monterey:       "7643426f0e6a8958f63fdc0cb0fe0c259e1da50eb22d19f74f26a53f62520309"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "97b70d9fd20c7fd47e0b50c2a1cdade309327051a43b6c9b0ec306971deabb7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5a5a9b188b427ad39f32bd45f8420f46e7bb0d4fc03e1eb46a3b1f78d97d67d"
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
