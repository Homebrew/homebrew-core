class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://www.wsi.uni-tuebingen.de/lehrstuehle/algorithms-in-bioinformatics/software/diamond/"
  url "https://github.com/bbuchfink/diamond/archive/v2.0.15.tar.gz"
  sha256 "cc8e1f3fd357d286cf6585b21321bd25af69aae16ae1a8f605ea603c1886ffa4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1e1daedcd1ea44e29b70859d57bcd6f0983b9d38ac27f32e63b1072002f452c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa0e405531a810c30e7e86414dd6bc5a1a3d362af243329008623c703134dafb"
    sha256 cellar: :any_skip_relocation, monterey:       "63dd3620cc1447aeb81b99e636301489ca6d2d3ba6a42f7c3c3432eacf82539b"
    sha256 cellar: :any_skip_relocation, big_sur:        "619e8ff1bbfe88b3336831c3f324ba076461cdbc5a9cf8638d510ca0bf1a9dd3"
    sha256 cellar: :any_skip_relocation, catalina:       "392f3045b0972f2ec771f1afd3349da404e0f083b57115dc093125247d22e5db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c3558c6daf8a9f202cc9c1ae5081aef8a5671f4b0879229e6b6d1e886fb91ce"
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
