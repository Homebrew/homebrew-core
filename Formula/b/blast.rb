class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.14.1/ncbi-blast-2.14.1+-src.tar.gz"
  version "2.14.1"
  sha256 "712c2dbdf0fb13cc1c2d4f4ef5dd1ce4b06c3b57e96dfea8f23e6e99f5b1650e"
  license :public_domain

  livecheck do
    url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/VERSION"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_ventura:  "5ac733bc4b3dd1dad7e31743523fbbda7e373ef046eedb5b63efd3337377278a"
    sha256 arm64_monterey: "48a21807f138f6f32c8961e3e42d6d95fe28c3ece6b044a99b0261a2f775683b"
    sha256 arm64_big_sur:  "14c11bab160ab54a32636d20f0e7d7966cd4e555c597e0b45b8b68c253d1fbf4"
    sha256 ventura:        "a037c5f6b34bfc3a6da7df53040982820f4fa6bc04b40d267029a5609bc70aa0"
    sha256 monterey:       "e03015a5f73afdd483c0a4b50641a4f536a838813f4eb080a10495b1ac7eb1b6"
    sha256 big_sur:        "b663ea74f93a8cb23661aab8b831bef3b1c11877bef219057e1361c4e12021ba"
    sha256 x86_64_linux:   "6a9d61075581b765efc9e632d1f72099a262fdcbac402db9bc6e052745d096a1"
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
