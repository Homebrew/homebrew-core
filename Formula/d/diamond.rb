class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://www.wsi.uni-tuebingen.de/lehrstuehle/algorithms-in-bioinformatics/software/diamond/"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.12.tar.gz"
  sha256 "0a11a09ee58f95a3b2e864d61957066faae8a37abaa120353c0faad5d0ff0778"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fff873950d646cf971fe6ca178c14cb98bb52be7c49492c68ddb41ddce68beb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ada44d444c51756e35427d8786f758791f8e5feaa692f5d428fdaef829f8025c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5ae80023e3367a9ffb850fbad6a3a02cdc41bf1c63b9d46dbb0dfc47373dbc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eda8e413a9e30a1685ad9aa6dc71145eb9af09a725131a5541f91df49548f54"
    sha256 cellar: :any_skip_relocation, ventura:       "5d01a78af15bfd158aa2c779f6e654ff2423c038b44ded09fc14655be2bb0ec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d28af69aea9ecc04dd5331448669f6e634b938439469b2f3f1e1f6c97958cf2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5476ecbbe5d8d39152e5094d131912a989c4245a723c3c8a7d0819488a132ae"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
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
