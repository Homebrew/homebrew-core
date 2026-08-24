class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.24/htslib-1.24.tar.bz2"
  sha256 "28a8de191381c7a97a35675ceac76fa1ea95e7b678d6a2e9d600a7874e4077de"
  license all_of: ["MIT", "BSD-3-Clause"]
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5fbfbd1e6936abb951a1035f66be1b343bddd425e8ce5e330bad96827e30208d"
    sha256 cellar: :any, arm64_sequoia: "557f5aff701fbb5d230be31d84000508e14bace991451776d7d91358f4c0121e"
    sha256 cellar: :any, arm64_sonoma:  "f8b2b0f9f21febb627c79195f52f8dcca98aa53614f5268947e119599a34957c"
    sha256 cellar: :any, sonoma:        "ef7eb37986f3a176eae80679018e6d2ac1b74a40f7cdf183308a6e8c0d6ee921"
    sha256 cellar: :any, arm64_linux:   "e0eac6114c0301bd47d94fda21c2e9b95212f919987ca33a83db7f528a906755"
    sha256 cellar: :any, x86_64_linux:  "f23d948a57a9dc4ef393ac5ef1c698897ffe49cf5f79aaf115e9353141993f47"
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
