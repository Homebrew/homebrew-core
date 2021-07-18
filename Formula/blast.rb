class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.12.0/ncbi-blast-2.12.0+-src.tar.gz"
  version "2.12.0"
  sha256 "fda3c9c9d488cad6c1880a98a236d842bcf3610e3e702af61f7a48cf0a714b88"
  license :public_domain

  livecheck do
    url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/VERSION"
    regex(/.+/i)
  end

  bottle do
    sha256 big_sur:      "8d32e53882b58c2ffec36a76764929759536cf72c5104337c599be08f8772aa0"
    sha256 catalina:     "b682885e3ef53795f010e04a55ebc607e82105b24d441f0354dda4fa2ce56b41"
    sha256 mojave:       "0d98042978cd28ea16e9e89f4b4f2ff318c67e662a11a9b9bf130d810ee1eb3f"
    sha256 high_sierra:  "5899dbfbdd65d6274b03eb0ed576d87a7bfc18a3d9a5b588fe30edddb554ce24"
    sha256 x86_64_linux: "885078c6d471be42a7736cfa2599bb4026963fb6a97f379d86af482ddf426e46"
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
