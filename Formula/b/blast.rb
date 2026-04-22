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
    rebuild 2
    sha256 arm64_tahoe:   "c899b804e8fe6495c89198d57cc47c37a3a75bd20bd671e224244ef956be8459"
    sha256 arm64_sequoia: "d94cb26d4736310ed0268b857ab3aa00879ab725e266a66eb6c325d4d620f222"
    sha256 arm64_sonoma:  "763dfe79ed5e4ad591893199cb2369622408869b3693731e08fdaa1b830ec607"
    sha256 sonoma:        "eb6553ea5219eb2369852aa9da77bc0afc683172707b0b2e49cdca45a0d25dbe"
    sha256 arm64_linux:   "5f1789a3a285888887723a7a606c0a74c072f99557ae5590a30b7ccfc088c2a0"
    sha256 x86_64_linux:  "08990287f4f3ae8cc07763209bfe7a5a52f04d79b9baca6207cdf50c25172ca9"
  end

  depends_on "lmdb"
  depends_on "mbedtls@3"
  depends_on "pcre2"

  uses_from_macos "cpio" => :build
  uses_from_macos "bzip2"
  uses_from_macos "sqlite"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
