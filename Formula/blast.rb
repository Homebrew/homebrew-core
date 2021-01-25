class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.11.0/ncbi-blast-2.11.0+-src.tar.gz"
  version "2.11.0"
  sha256 "d88e1858ae7ce553545a795a2120e657a799a6d334f2a07ef0330cc3e74e1954"
  license :public_domain

  livecheck do
    url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 "8d32e53882b58c2ffec36a76764929759536cf72c5104337c599be08f8772aa0" => :big_sur
    sha256 "b682885e3ef53795f010e04a55ebc607e82105b24d441f0354dda4fa2ce56b41" => :catalina
    sha256 "0d98042978cd28ea16e9e89f4b4f2ff318c67e662a11a9b9bf130d810ee1eb3f" => :mojave
    sha256 "5899dbfbdd65d6274b03eb0ed576d87a7bfc18a3d9a5b588fe30edddb554ce24" => :high_sierra
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
