class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.15.0/ncbi-blast-2.15.0+-src.tar.gz"
  version "2.15.0"
  sha256 "6918c370524c8d44e028bf491e8f245a895e07c66c77b261ce3b38d6058216e0"
  license :public_domain

  livecheck do
    url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/VERSION"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_sonoma:   "c94e6f275774f19ae13655c4a060728c79101c0450686afb80cff7a9a2d211d1"
    sha256 arm64_ventura:  "7b57dceca3f83fa852fa225dc8a749a2f46af68c1234bd8694cc19411323c91e"
    sha256 arm64_monterey: "f35317bdbed37113b13278e32228ec0f941b2bedd62a7623b5ed1b7638a1769b"
    sha256 sonoma:         "014528e069266455d50f9e8073e54d24ed5125b3fb01d7e20380700453746e05"
    sha256 ventura:        "a96e1d915905547dff084c59a55c656422076e22719a0ff82819c36a2f9fe64c"
    sha256 monterey:       "d0ed36de012c79a90fa3b9ecaae13092f5bb1cab51f0cb39f5d43ba90b2a4662"
    sha256 x86_64_linux:   "8522583e6941497542ca844027479240ba5e248e9099d32579688e3eef6a707e"
  end

  depends_on "lmdb"

  uses_from_macos "cpio" => :build
  uses_from_macos "bzip2"
  uses_from_macos "sqlite"
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

      if OS.mac?
        # Allow SSE4.2 on some platforms. The --with-bin-release sets --without-sse42
        args << "--with-sse42" if Hardware::CPU.intel? && OS.mac? && MacOS.version.requires_sse42?
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
