class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.9.0/ncbi-blast-2.9.0+-src.tar.gz"
  version "2.9.0"
  sha256 "a390cc2d7a09422759fc178db84de9def822cbe485916bbb2ec0d215dacdc257"

  bottle do
    sha256 "9fef86c970bdc8556a479920bffd3d33a57c0ce7bdcad4c44f2469e116f940aa" => :catalina
    sha256 "e07f0dafa79bd72359cf467ba8cf8e51d76665c1571128dc7cc5d7857c5b92d8" => :mojave
    sha256 "3de6646d96d9fdbf6b76fdf57a14612c8eebbfa1327f0d42e0402b516b6298ec" => :high_sierra
    sha256 "57f2e2f9c65aa5364eb72a9bbdf6948a30af2975a53445a4b43203f56395da7c" => :sierra
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
