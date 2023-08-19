class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.14.0/ncbi-blast-2.14.0+-src.tar.gz"
  version "2.14.0"
  sha256 "bf477f1b0c3b82f0b7a7094bf003a9a83e37e3b0716c1df799060c4feab17500"
  license :public_domain

  livecheck do
    url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/VERSION"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_ventura: "ef7f64b650ddd5bd5a1dfb7607866653506dc4ea4b1002e17ec1ac0b0b2e6753"
    sha256 arm64_big_sur: "0239f0d621e069cfaff7c7efd2e340986fa7dc81a19a1d5ff06afc651339d9ac"
    sha256 ventura:       "d44e031c5bb344160bfcd823e31d4e01416930e5d304edcc0a5cc4b9d668fa3b"
    sha256 monterey:      "ccb2bf7d47607eb7a2bda69666bfa26d592132bef1b65f2b8ffec0ef35f97713"
    sha256 big_sur:       "8b56e231976a2fc415ed0e8a95c311c098a602241bd535b777c783d5e33959df"
    sha256 x86_64_linux:  "feb66ab235cf31ad8ea401aa3923e2066988f85580b3aa44c0acc028dee49e0d"
  end

  depends_on "lmdb"

  uses_from_macos "cpio" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "proj", because: "both install a `libproj.a` library"

  fails_with gcc: "5" # C++17

  def install
    cd "c++" do
      # Boost is only used for unit tests.
      args = %W[
        --prefix=#{prefix}
        --with-bin-release
        --with-mt
        --without-strip
        --with-experimental=Int8GI
        --without-debug
        --without-boost
      ]
      # Allow SSE4.2 on some platforms. The --with-bin-release sets --without-sse42
      args << "--with-sse42" if Hardware::CPU.intel? && MacOS.version.requires_sse42?

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
