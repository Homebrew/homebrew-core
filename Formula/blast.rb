class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.12.0/ncbi-blast-2.12.0+-src.tar.gz"
  version "2.12.0"
  sha256 "fda3c9c9d488cad6c1880a98a236d842bcf3610e3e702af61f7a48cf0a714b88"
  license :public_domain

  livecheck do
    url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/VERSION"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_big_sur: "e216b2d4b0c1950faedfe6a32dfcedecc524be9f237cdf09450e9fac7414f1e1"
    sha256 big_sur:       "4e12ddaa5006c50497f9ad77f18f1b971db88c8b7e2de15f229661611a0a8772"
    sha256 catalina:      "81cf9bbb6066d31f5018f3697b9872f051efd99b4de5379924997eee7a2becb2"
    sha256 mojave:        "f4f05cdbb102aa7597865c2dd42372181577f00a7aaac7be9f2f315714d5f352"
    sha256 x86_64_linux:  "a3284452baea3a3a9d7b078f642e267eb2bd0f1612502313994ac7a8f44aa303"
  end

  depends_on "lmdb"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "libarchive" => :build
  end

  conflicts_with "proj", because: "both install a `libproj.a` library"

  def install
    cd "c++" do
      # Boost is only used for unit tests.
      args = %W[--prefix=#{prefix}
                --without-debug
                --without-boost]

      on_macos do
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
