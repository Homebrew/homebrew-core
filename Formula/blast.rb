class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.8.1/ncbi-blast-2.8.1+-src.tar.gz"
  version "2.8.1"
  sha256 "e03dd1a30e37cb8a859d3788a452c5d70ee1f9102d1ee0f93b2fbd145925118f"

  bottle do
    sha256 "878c83917ebf683d6555669bdab9052eefc13c1bc7b954a3306db0a34709e862" => :mojave
    sha256 "c16d8d858839b6fcfb8c024b3d001a3cd6deb4b1dfee3d37a4f37aabdc525651" => :high_sierra
    sha256 "0d67fc57e7ac3fb1d208166b2795f6553c8279c57b67ce6b399e398c657a887d" => :sierra
  end

  depends_on "lmdb"

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
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    output = shell_output("#{bin}/blastn -query test.fasta -subject test.fasta")
    assert_match "Identities = 70/70", output
  end
end
