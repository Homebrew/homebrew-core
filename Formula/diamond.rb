class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://ab.inf.uni-tuebingen.de/software/diamond/"
  url "https://github.com/bbuchfink/diamond/archive/v0.9.25.tar.gz"
  sha256 "65298f60cf9421dcc7669ce61642611cd9eeffc32f66fd39ebfa25dd64416808"

  bottle do
    cellar :any_skip_relocation
    sha256 "d142fdeb7bcaf6fe11a63bea7027d7e71a16165243ec1a4e1bc319941ffea21f" => :mojave
    sha256 "2ea545335e21704468d960aae7b9d5702e7a0bcb7540cc7ca6bb872ecce4bb50" => :high_sierra
    sha256 "a7eb2dad7dece443eeb54b53084bc7c715f221067dce51d7e238214dc402b2d2" => :sierra
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
    assert_match "Processed 6 sequences, 572 letters.", output
  end
end
