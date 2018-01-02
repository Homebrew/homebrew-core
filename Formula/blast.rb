class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.6.0/ncbi-blast-2.6.0+-src.tar.gz"
  mirror "ftp://ftp.hgc.jp/pub/mirror/ncbi/blast/executables/blast+/2.6.0/ncbi-blast-2.6.0+-src.tar.gz"
  version "2.6.0"
  sha256 "0510e1d607d0fb4389eca50d434d5a0be787423b6850b3a4f315abc2ef19c996"
  revision 3

  depends_on "python" if MacOS.version <= :snow_leopard

  # Remove for > 2.6
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5fa7fda60c17a2a31e402522d0f7e5584d3b946b/blast/blast-make-fix2.5.0.diff"
    sha256 "ab6b827073df48a110e47b8de4bf137fd73f3bf1d14c242a706e89b9c4f453ae"
  end

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
