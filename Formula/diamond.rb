class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://ab.inf.uni-tuebingen.de/software/diamond/"
  url "https://github.com/bbuchfink/diamond/archive/v0.9.17.tar.gz"
  sha256 "cda79a6c3de73545dc783722edb17ae0828efb2553eac113e0e2c1d354686edc"

  bottle do
    cellar :any_skip_relocation
    sha256 "64338c24d7fa0b5902dbd4c8f1bfb6e3d58e86013b04b6d75c26be22f3ae24f7" => :high_sierra
    sha256 "92c5a391925c16117986c71105d59166ad0649d1135f2ec1feaa2f7a278745c1" => :sierra
    sha256 "06fff16eb4c7725421617276cb3096f8eca33aa9d754aac68c02b0f9a6234b39" => :el_capitan
  end

  depends_on "cmake" => :build

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
    output = shell_output("#{bin}/diamond makedb --in nr.faa -d nr")
    assert_match "Processed 6 sequences, 572 letters.", output
  end
end
