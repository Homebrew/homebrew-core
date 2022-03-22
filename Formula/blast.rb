class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.13.0/ncbi-blast-2.13.0+-src.tar.gz"
  version "2.13.0"
  sha256 "89553714d133daf28c477f83d333794b3c62e4148408c072a1b4620e5ec4feb2"
  license :public_domain

  livecheck do
    url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/VERSION"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_big_sur: "2bf18560fdbeeba904b1c064de2d7485f5f478ed8608124ba034889b8372518a"
    sha256 monterey:      "8b52442d8fccc8f099cf06b3f5c047eedbb3823326d0ea1a4e61cae535231295"
    sha256 big_sur:       "ee3a1af3ae297a89e2c9faadbf0e9f677d06540777fefa72503fe7d9cde69d56"
    sha256 catalina:      "2a649294c81ba2449ed122c981359b05273bfd51d200c0cd56a0819458808b1f"
    sha256 x86_64_linux:  "5ed46b12d1329eac692b299b62d19b1785154ea56df348da9592840f73da8880"
  end

  depends_on "lmdb"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "libarchive" => :build
    depends_on "gcc"
  end

  conflicts_with "proj", because: "both install a `libproj.a` library"

  fails_with gcc: "5" # C++17

  def install
    cd "c++" do
      # Boost is only used for unit tests.
      args = %W[--prefix=#{prefix}
                --with-bin-release
                --with-mt
                --with-strip
                --with-experimental=Int8GI
                --without-debug
                --without-boost]

      if OS.mac?
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
