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
    rebuild 1
    sha256 arm64_big_sur: "2976fc131888183295514f2e2d2ff32c91cc2f15b76361c37d2a9414283c16ff"
    sha256 monterey:      "414d2727bccb077a0d655d50508c8be5246e429eb9a3285524122846836c6822"
    sha256 big_sur:       "2fd23535ef7180812f7d16abf25590cc99a1689fc3edcfe1fbb84cd79c65e1a3"
    sha256 catalina:      "a044ffeb208ed5b4de37cba25e584b74b571368ad4ed5260155f671981ccd4ae"
    sha256 mojave:        "3ccce772ca8ef7f25343f13bd43cc8f12e0d4288306bf6bcde5d2303e112e378"
    sha256 x86_64_linux:  "bbc0b4c269fd0899d3506763f48264248af36a367c7fae3a032199be666ed65e"
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
