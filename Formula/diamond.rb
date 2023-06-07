class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://www.wsi.uni-tuebingen.de/lehrstuehle/algorithms-in-bioinformatics/software/diamond/"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.7.tar.gz"
  sha256 "2dcaba0e79ecb02c3d2a6816d317e714767118a9a056721643abff4c586ca95b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9dfe0ee5009f281b808c3112974691830f5b60676728286e1292e4d1bec5600"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fbf7a00d7355b549deffdc0adc3d46157ee77ad662c660592c28547bfd6539b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "141e673bda89008dc83cda5e20c435828bc140adecec7ba2194417269495f550"
    sha256 cellar: :any_skip_relocation, ventura:        "3620b9e161f3186257bd4f1a1e0e0916d99106019fa75974b2961a7e9a5af5d1"
    sha256 cellar: :any_skip_relocation, monterey:       "36d3eef3c47cfc1751c0d38cb4538b4d0cdcb559bd63bf44d6db8edb350982b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a82872f50e41ac0a8f78386787a518115054921ea2fec93b89257a7fa65f8518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98b7f90efa2cdfa961d93425c152b9eac5f977d09331012b48bb1890d51863a9"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"nr.faa").write <<~EOS
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf1
      grarwltpvipalweaeaggsrgqeietilantvkprlyXkyknXpgvvagacspsysgg
      XgrrmaXtreaelavsrdratalqpgrqsetpsqkk
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf2
      agrggsrlXsqhfgrprradhevrrsrpswltrXnpvstkntkisrawwrapvvpatrea
      eagewrepgrrslqXaeiaplhsslgdrarlrlkk
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf3
      pgavahacnpstlggrggritrsgdrdhpgXhgetpsllkiqklagrgggrlXsqllgrl
      rqengvnpgggacseprsrhctpawaterdsvskk
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf-1
      fflrrslalsprlecsgaisahcklrlpgsrhspasasrvagttgarhharlifvflvet
      gfhrvsqdgldlltsXsarlglpkcwdyrrepprpa
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf-2
      ffXdgvslcrpgwsavarsrltassasrvhaillpqppeXlglqapattpgXflyfXXrr
      gftvlarmvsisXprdppasasqsagitgvshrar
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf-3
      ffetesrsvaqagvqwrdlgslqapppgftpfsclslpsswdyrrppprpanfcifsrdg
      vspcXpgwsrspdlvirpprppkvlglqaXatapg
    EOS
    output = shell_output("#{bin}/diamond makedb --in nr.faa -d nr 2>&1")
    assert_match "Database sequences  6\n  Database letters  572", output
  end
end
