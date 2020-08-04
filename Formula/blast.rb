class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.10.1/ncbi-blast-2.10.1+-src.tar.gz"
  version "2.10.1"
  sha256 "110729decf082f69b90b058c0cabaea38f771983a564308ae19cb30a68ce7b86"
  license "LGPL-2.1"

  bottle do
    sha256 "652c133a61840c1a1f69de4f5827bd358434f3d7caa7886c273b3bab034e0721" => :catalina
    sha256 "b544b1e6e510c0c72b82b581a17eb8704ad53e46e9574d4dfd24bef8f5044148" => :mojave
    sha256 "9dd8d68f78e3825fc33064bc3b79d6474d56593e7260d39ab5f6408ad2e1e939" => :high_sierra
  end

  depends_on "lmdb"

  uses_from_macos "cpio" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  conflicts_with "proj", because: "both install a `libproj.a` library"

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
