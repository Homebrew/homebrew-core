class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://www.wsi.uni-tuebingen.de/lehrstuehle/algorithms-in-bioinformatics/software/diamond/"
  url "https://github.com/bbuchfink/diamond/archive/v2.0.13.tar.gz"
  sha256 "9b79c3a01913999dfa2543f4dd7a3494397a8723ea587207c14683b24e57eac1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0818f8c47ac2ccbf580123574e6cb4ab76401dd676f6bf72e97bfb065de675ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ef150a0590fade52830bdb09326c1f31bb57e4eea780d2a433dd9d15d2e4b85"
    sha256 cellar: :any_skip_relocation, monterey:       "c2ef66c9bf0cfe84f3626d6e05af6edb97b9d6be179c33ba8f6dc1a6102ccc34"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb4f7bb3e69cc52f5d92990211081cdd04e378feb4d1854bc89f2c8f0cfc6b94"
    sha256 cellar: :any_skip_relocation, catalina:       "4c8f60340e8c71742114b5f08c8260fc1b284ad58e75a2ce07eb14164226e2fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e4306d9ea85e4bfe0ee7dcc239c42ba2941d5dd6a86ada432dba8e10e380566"
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
