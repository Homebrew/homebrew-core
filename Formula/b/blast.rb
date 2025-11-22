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
    sha256 arm64_tahoe:   "4700bd0ebfdf363a0e307f8656826bc8f4643400738f0fb3c3ddaf4fcc912a17"
    sha256 arm64_sequoia: "b4aff3c97ccd466c20d2aabc43ec9fd315b10b8f99d02ea81baa2b145524740d"
    sha256 arm64_sonoma:  "f03bb62ca8ede3be78fc946c28fba03acea414632dae14de29ba4bc400cdd217"
    sha256 sonoma:        "8688084ae1bdb3c7beaeb415c2da42703e208265964bf9efb5bf03627792d8fe"
    sha256 arm64_linux:   "3af4336ac05e7fce279f047283bcc876a712f7139c7e1d0279c635a2adaa535b"
    sha256 x86_64_linux:  "0443138a85b9cd22f0006a6819ef26ba5633b389d857751b3d58c35111bba0e7"
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
        inreplace "src/build-system/Makefile.mk.in" do |s|
          cmprs_lib = s.get_make_var("CMPRS_LIB").split
          cmprs_lib.delete("zcf")
          s.change_make_var! "CMPRS_LIB", cmprs_lib.join(" ")
        end
      end

      # Boost is only used for unit tests.
      args = %W[
        --prefix=#{prefix}
        --with-bin-release
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
