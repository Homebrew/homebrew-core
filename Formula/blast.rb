class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"

  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.6.0/ncbi-blast-2.6.0+-src.tar.gz"
  mirror "ftp://ftp.hgc.jp/pub/mirror/ncbi/blast/executables/blast+/2.6.0/ncbi-blast-2.6.0+-src.tar.gz"
  version "2.6.0"
  sha256 "0510e1d607d0fb4389eca50d434d5a0be787423b6850b3a4f315abc2ef19c996"
  revision 4

  depends_on :python if MacOS.version <= :snow_leopard

  patch do
    # Fixed upstream in future version > 2.6
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/blast/blast-make-fix2.5.0.diff"
    sha256 "ab6b827073df48a110e47b8de4bf137fd73f3bf1d14c242a706e89b9c4f453ae"
  end

  def install
    # The libraries conflict with ncbi-c++-toolkit.
    args = %W[--prefix=#{prefix} --libdir=#{libexec} --without-debug]

    # Fix error: allocating an object of abstract class type 'ncbi::CNcbiBoostLogger'
    # Boost is used only for unit tests.
    # See https://github.com/Homebrew/homebrew-science/pull/3537#issuecomment-220136266
    args << "--without-boost"

    cd "c++" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    output = shell_output "#{bin}/blastn -query test.fasta -subject test.fasta"
    assert_match "Identities = 70/70", output
  end
end
