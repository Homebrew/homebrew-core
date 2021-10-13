class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://www.wsi.uni-tuebingen.de/lehrstuehle/algorithms-in-bioinformatics/software/diamond/"
  url "https://github.com/bbuchfink/diamond/archive/v2.0.12.tar.gz"
  sha256 "d0468959ea677cc8e90a6fbd9506f3fb1fbd1b415d30bf398ac2524bb5b6f20c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c60ab9a0136b88b8e4acbaf8b8826f3822f921730f4a5b4317ac205c93f36b94"
    sha256 cellar: :any_skip_relocation, big_sur:       "cde37828d32153f2ed9501684c519a5c900e142a77154bf283aa8e6214e73bfa"
    sha256 cellar: :any_skip_relocation, catalina:      "cb016605b352a851fe612198eb1b0a7db3fc03a05a05e5ae418ae76b41cc634a"
    sha256 cellar: :any_skip_relocation, mojave:        "8f14421cb230d2fcbd42f02854475b431296b09a1a29e23d408dd64badc43a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86d326765512f2d726bacf7a21d7676c1fbb5a6e1bac3836b4e624cecf0e0b7d"
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
