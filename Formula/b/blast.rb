class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.17.0/ncbi-blast-2.17.0+-src.tar.gz"
  version "2.17.0"
  sha256 "502057a88e9990e34e62758be21ea474cc0ad68d6a63a2e37b2372af1e5ea147"
  license :public_domain
  revision 1

  livecheck do
    url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/VERSION"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "2256a8f9c1ad1d1d30b130f3fac419318960808a6f8eeb5006dacaa02c244f45"
    sha256 arm64_sequoia: "d50a891f6c0ae6fe37df0f6481f5a78f812763aa4fd6f39197f3084891c895a5"
    sha256 arm64_sonoma:  "9f648acc80960502a9e501814236ec24b8954d926449273a9d393bf8c59c5975"
    sha256 sonoma:        "5c735e79ad0138e48d87459f2cb52be1f54684a3f03bb4b225a6ffc9c4e4beec"
    sha256 arm64_linux:   "6f913987e18636b0fe5bd74e964eeb50c113f07c89df72681d449f2a8449adf1"
    sha256 x86_64_linux:  "7bbf1d59756daaf6a6dc1c07d01a2238b73760fad9cadcd4181f292a69b1c940"
  end

  depends_on "lmdb"
  depends_on "mbedtls@3"
  depends_on "pcre2"

  uses_from_macos "cpio" => :build
  uses_from_macos "bzip2"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "proj", because: "both install a `libproj.a` library"

  def install
    cd "c++" do
      # Remove bundled libraries to make sure the brew/system libraries are used
      %w[compress/bzip2 compress/zlib lmdb regexp].each do |lib_subdir|
        rm_r("include/util/#{lib_subdir}") if lib_subdir != "regexp"
        rm_r("src/util/#{lib_subdir}")
      end
      rm_r(Dir["include/util/regexp/*"] - ["include/util/regexp/ctre"])

      # Remove Cloudflare zlib on arm64 linux as it requires a minimum of armv8-a+crc
      # TODO: re-enable if we increase our minimum march to require crc
      if Hardware::CPU.arm? && OS.linux?
        rm_r("include/util/compress/zlib_cloudflare")
        rm_r("src/util/compress/zlib_cloudflare")

        zcf_files = ["src/build-system/Makefile.mk.in", "src/util/compress/api/Makefile.compress.lib"]
        inreplace zcf_files, /(=.*) zcf(\s)/, "\\1\\2"
      end

      # Boost is only used for unit tests.
      args = %W[
        --prefix=#{prefix}
        --with-bin-release
        --with-dll
        --with-mbedtls=#{Formula["mbedtls@3"].opt_prefix}
        --with-mt
        --with-pcre2=#{Formula["pcre2"].opt_prefix}
        --without-strip
        --with-experimental=Int8GI
        --without-debug
        --without-boost
        --without-internal
      ]

      if OS.mac?
        # Allow SSE4.2 on some platforms. The --with-bin-release sets --without-sse42
        args << "--with-sse42" if Hardware::CPU.intel? && MacOS.version.requires_sse42?
        args += ["OPENMP_FLAGS=-Xpreprocessor -fopenmp",
                 "LDFLAGS=-lomp"]
      end

      system "./configure", *args

      # Fix the error: install: ReleaseMT/lib/*.*: No such file or directory
      system "make"
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/update_blastdb.pl --showall")
    assert_match "nt", output

    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    output = shell_output("#{bin}/blastn -query test.fasta -subject test.fasta")
    assert_match "Identities = 70/70", output

    # Create BLAST database
    output = shell_output("#{bin}/makeblastdb -in test.fasta -out testdb -dbtype nucl")
    assert_match "Adding sequences from FASTA", output

    # Check newly created BLAST database
    output = shell_output("#{bin}/blastdbcmd -info -db testdb")
    assert_match "Database: test", output
  end
end
