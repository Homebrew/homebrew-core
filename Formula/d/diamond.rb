class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "d06d26cfa474e17132a9ea4c0a2a7ce4ec7e2ce937606173b401883d62eff730"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3e69f7f5b7b92d335de4b98bcd8398925227675f8f120992ca44cd795358de7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "622377d3ba4cfb50e49d85e523af4f8bff24532a32b0c869eba15e97d9277ac0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29d26af781608771feb8896ff1528db0b68e1e98998a999364a9306748f5dd97"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecb12efad1a38e2a05176f66fe84b862427c1c999a28bfe406b109d872d935f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "809f12de9c7f4d6ea499435e497fee8b77a6fbc161f5a95bb74a738a9eef52a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81339d78d33babfa714699e616e87cea29c8e723b1290c1230c0c53c6d995069"
  end

  depends_on "cmake" => :build

  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
