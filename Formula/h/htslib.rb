class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.25/htslib-1.25.tar.bz2"
  sha256 "158c271e4e2986bb2dd11283b640edc10c56695b293df77a109ce99480303730"
  license all_of: ["MIT", "BSD-3-Clause"]
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f6fffd5e60809ca366c36a88857cdbb5b08439096449e0d5f6183ae7f9a6e838"
    sha256 cellar: :any, arm64_tahoe:       "82449dd9519fd1399fc3afbf4c6c71dbb554de80aae76a6472b743477d47cf9f"
    sha256 cellar: :any, arm64_sequoia:     "93facfb91f1ea0426afc19bbac3c90a0f07f1f4e3dc5aba030f9656d8defe75f"
    sha256 cellar: :any, arm64_linux:       "114bd0fa08392cbdc70b8605602b00c1b1960cea579776644b1cab4ecdebcd8d"
    sha256 cellar: :any, x86_64_linux:      "b872122faad374b5469a29824bac6bd149b528a3edf6407ebd8ed2322df8ab9d"
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
