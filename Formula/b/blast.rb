class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.16.0/ncbi-blast-2.16.0+-src.tar.gz"
  version "2.16.0"
  sha256 "17c93cf009721023e5aecf5753f9c6a255d157561638b91b3ad7276fd6950c2b"
  license :public_domain

  livecheck do
    url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/VERSION"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_sequoia:  "b5317b48fe420d58afd074b19f0d36380788ef46a4a75593b9ed1b2cb397de90"
    sha256 arm64_sonoma:   "8e77abd1cdf1e35d25d701327042d1e33902f968cc34ed36951c6b784fd12f7d"
    sha256 arm64_ventura:  "7a33345e002e745fe513ee84e81074259e3225e9e45fdec0531feb9af097f76e"
    sha256 arm64_monterey: "2ea7535bc0267077b6afdd622a1860a50509a1d3c3cb9d91df9b8a3b5fe4de7c"
    sha256 sonoma:         "c11dfa24a469e44b56cd270a532f8a5e341f02b9a41aa07b112d48054d76d901"
    sha256 ventura:        "3aa4433e3e7235441f8418f97c9bac09cbb98f569c008922a0d732344fd95017"
    sha256 monterey:       "946e1a0a2892aea9e93441a147355baa9d3e87626c052f847c7cf37c397e2fb4"
    sha256 arm64_linux:    "c07e41c4822efda75a3ec410aacc1aac239ed58cf1aec77fb8c410cc46ff3867"
    sha256 x86_64_linux:   "a9fb9b0ec8fdfe89cf32b175ff180d160134d99e542f0329466cf9f7a545139b"
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
