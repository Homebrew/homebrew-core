class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://www.wsi.uni-tuebingen.de/lehrstuehle/algorithms-in-bioinformatics/software/diamond/"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.9.tar.gz"
  sha256 "4cde9df78c63e8aef9df1e3265cd06a93ce1b047d6dba513a1437719b70e9d88"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d77fd0fe164cab01bfebe01a9b6fb159fc7de42eb5b5d44f68b16da33057dff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "412798431c80d3e6e8e20d93733232d75bc11f2f995fce977b60fa942c7510ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdbec7a29efdbfc33141259a64a6656af138ce0de88f050e52c939a7f1bb0eb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b720715f17ff04ed633d7b64df64d85e17628e09609c198105864870e385161f"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f9a843d8b2c574fe5ec194ae3bdaf5cdff7379ba3de4f67ba0cccffcebe3374"
    sha256 cellar: :any_skip_relocation, ventura:        "057c98f7ec36d1dbb062385d7bffac48d908bf1a0a90e596386568740c6bfd9f"
    sha256 cellar: :any_skip_relocation, monterey:       "ebe23848f2cbee8fd24deb51ac80c68dcc55fedef96fc6af1505fe11b1edaa99"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c83ebc8674e1911e3ca03a0f2c869df72524352913917ad8db48d079f0e46f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8720bc485263d2f1cb9d489d3472942caa7f6bcde6c270719104c6422686106d"
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
