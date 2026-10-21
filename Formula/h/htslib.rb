class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.24/htslib-1.24.tar.bz2"
  sha256 "28a8de191381c7a97a35675ceac76fa1ea95e7b678d6a2e9d600a7874e4077de"
  license all_of: ["MIT", "BSD-3-Clause"]
  revision 1
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c5b965119fbadd299b52d1027d37d45935bd620688998b9fd8d1beee6575afc6"
    sha256 cellar: :any, arm64_tahoe:       "1b689c59676a02ec5bf4bacc7e5618e5bd730f7d7e945c78c632199008140c4d"
    sha256 cellar: :any, arm64_sequoia:     "2ed460ed1b562c2dcd648482a8e4d75238b4b42254f92aa630287312121afdb4"
    sha256 cellar: :any, arm64_linux:       "c2513ad5af566d4ddb92f8bdd4bad8a69970ed3341f74575ac0fe54e94d09808"
    sha256 cellar: :any, x86_64_linux:      "01186d0699578a32d66f82be9b3529da09fb809d00c6ffcdac0c0cb0c2d7f303"
  end

  depends_on "libdeflate"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
