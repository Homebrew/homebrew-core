class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://ab.inf.uni-tuebingen.de/software/diamond/"
  url "https://github.com/bbuchfink/diamond/archive/v0.9.32.tar.gz"
  sha256 "70de59e0c48faf23d14c2e6a7e00ddb3984cc1f59995b63658abc90be3810ecd"

  bottle do
    cellar :any_skip_relocation
    sha256 "c29a7d4156c8c9baca8293e1f3bf61c049ddc8255ee15c921ddab95c7565a892" => :catalina
    sha256 "137b70ee50757c1377e1fcf4988a5a31aaaef3e8e6077f4c1b9e1f058d927fe1" => :mojave
    sha256 "39c75f043a7d328404409c1efa7642ba59d1afdd87fa9ba09aa7d111f74490f6" => :high_sierra
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
