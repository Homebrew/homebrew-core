class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.17.0/ncbi-blast-2.17.0+-src.tar.gz"
  version "2.17.0"
  sha256 "502057a88e9990e34e62758be21ea474cc0ad68d6a63a2e37b2372af1e5ea147"
  license :public_domain

  livecheck do
    url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/VERSION"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0eecc5bf5fb52ae2ff1d7e9b8f3fedbb2a86e1035134dd225712fc384f40ce22"
    sha256 arm64_sequoia: "43b03b4a7d9f076440ef147018ea8a3f42ad7de5ba7da730f4f615679a1d5444"
    sha256 arm64_sonoma:  "5284fffd2eb9362ab6fd8b9c3e25e0eee0917df9cdcc82c348a902c9416c6f21"
    sha256 sonoma:        "ea0aa56daf9e728df8b45665414913decad4154430be7168ac37b9dd4996e595"
    sha256 arm64_linux:   "d5f36159d91bcf5198cf065b3816abd71257159d8be467df16776f94b98707cc"
    sha256 x86_64_linux:  "70d6e2f88cfa5cdbdd85b3edda9a5ee1bc7637554428cad194c12c2c60d583f1"
  end

  depends_on "lmdb"
  depends_on "mbedtls"
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
        --with-mbedtls=#{Formula["mbedtls"].opt_prefix}
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
