class Any2fasta < Formula
  desc "Convert various sequence formats to FASTA"
  homepage "https://github.com/tseemann/any2fasta"
  url "https://github.com/tseemann/any2fasta/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "73f4f2c1eb0cb5525703a5368fe4b34ddd252e64af1f9c3aba2ba63d8f9723b6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bba7ed684a5d3c4472a5c4aa1bac8c7aadc293bf6e6e198a35ca094bfd867d28"
  end

  uses_from_macos "perl"

  def install
    bin.install "any2fasta"
  end

  test do
    # https://github.com/tseemann/any2fasta/blob/master/test/test.clw
    (testpath/"test.clw").write <<~CLW
      CLUSTAL W (1.81) multiple sequence alignment

      gene02          ATGCTAGAATATGCTCTGAG--ATATTCAATATATCGTGCTAGGATATGCTCTGAGATAT
      gene01          ATGCRAGGATATGCTCTGAGATATATTCTATATATCGTGCTAGGATATGCTCTGAGATAT
      gene03          ATGCT---ACATGCTCTGAGACATATTCTATATATCGTGCTAGG---TGCTCTGAGATAT
                      ****    * **********  ****** ***************   *************

      gene02          ANNCTAGATATCGGCTAGGATATGTTCTGAGATATATTCTTTTATATCG
      gene01          ATTCTATATATCGGCTAGGATATGCTCTGAGATATATTC-TATATATCG
      gene03          ATTCTATATATCGGCTAGGATATGCTCTGAGATATATTC-TATATATCG
                      *  *** ***************** ************** * *******
    CLW

    assert_match <<~FASTA, shell_output("#{bin}/any2fasta -q test.clw")
      >gene02
      ATGCTAGAATATGCTCTGAG--ATATTCAATATATCGTGCTAGGATATGCTCTGAGATAT
      ANNCTAGATATCGGCTAGGATATGTTCTGAGATATATTCTTTTATATCG
      >gene01
      ATGCRAGGATATGCTCTGAGATATATTCTATATATCGTGCTAGGATATGCTCTGAGATAT
      ATTCTATATATCGGCTAGGATATGCTCTGAGATATATTC-TATATATCG
      >gene03
      ATGCT---ACATGCTCTGAGACATATTCTATATATCGTGCTAGG---TGCTCTGAGATAT
      ATTCTATATATCGGCTAGGATATGCTCTGAGATATATTC-TATATATCG
    FASTA
  end
end
