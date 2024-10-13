class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://www.wsi.uni-tuebingen.de/lehrstuehle/algorithms-in-bioinformatics/software/diamond/"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.9.tar.gz"
  sha256 "4cde9df78c63e8aef9df1e3265cd06a93ce1b047d6dba513a1437719b70e9d88"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7f29903daf1b665089c445986352c34fdfbf6d329425729b579074b1719a97f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8073e591bbda4cc5584b3c9fb144ab2a878ddb9581f2121c6033c73eed1a2155"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bb29de8405333bb24e9b63db81331235c8a91583cf53cddc792b8e2ae3468e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "682642aa18cd3fdab51d2257b7ba322f0eb94515ec04e969013ea5dd68e12dcf"
    sha256 cellar: :any_skip_relocation, sonoma:         "14dc8fc100b82d3644eb4daaf7db1fe2e293bd4d27c8f3187378680593a22cff"
    sha256 cellar: :any_skip_relocation, ventura:        "53f78cd6c8a51aff36773d9ea746fd3a005531649844f624858828cf218c2ce7"
    sha256 cellar: :any_skip_relocation, monterey:       "98c041f010ea94d7a1242098d46ddef43f7bd4271f2755785cab9e3523dc3f40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7960f5546b5e0fd4c7795ff2259623a1ef63025fc30fdda50194a7662ef4efc3"
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
