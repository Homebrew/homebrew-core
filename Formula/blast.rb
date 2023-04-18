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
    rebuild 1
    sha256 arm64_big_sur: "78881b3e87d3fb5d3fa1aef2a25d8390097432de3a5d10521ca5fb4e7ca56496"
    sha256 monterey:      "e144139a12c6f56996071cb3efcb57b552f937d0dfef61d577f12f9436cf8775"
    sha256 big_sur:       "9d406671f65bb9271f1564d6dcd3dcb7adfda11304c856632c30338b282e5891"
    sha256 catalina:      "9e06f6116d53ee375d166487ffa8dff40a7083dc2fdc70e4f4f2b9a49e96ca11"
    sha256 x86_64_linux:  "3313233f45a9a7cdde4867c98404ea0bf5b10f7827a188b935599a24885a01e1"
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
        --with-strip
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
