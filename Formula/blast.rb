class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.10.0/ncbi-blast-2.10.0+-src.tar.gz"
  version "2.10.0"
  sha256 "3acdd9cec01c4f43e56aeaf89049cb8f8013d60b9c1705eced10166967f1d926"

  bottle do
    rebuild 1
    sha256 "71ebf77b85de24cac6384b796b7b6a70fcaaeded84e1534bbfc4ba86030289d8" => :catalina
    sha256 "4da358f7b8d0fdc4b3d3a47ee16e0f6345c0846d76a692bdfeb7a7e0f84a12dd" => :mojave
    sha256 "0f8ce869239db65218854d9897bc47108d08a33d4f35d7afb56c22f1dc4a24ba" => :high_sierra
  end

  depends_on "lmdb"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  conflicts_with "proj", :because => "both install a `libproj.a` library"

  def install
    cd "c++" do
      # Use ./configure --without-boost to fix
      # error: allocating an object of abstract class type 'ncbi::CNcbiBoostLogger'
      # Boost is used only for unit tests.
      # See https://github.com/Homebrew/homebrew-science/pull/3537#issuecomment-220136266
      system "./configure", "--prefix=#{prefix}",
                            "--without-debug",
                            "--without-boost"

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
