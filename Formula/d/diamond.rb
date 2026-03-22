class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.24.tar.gz"
  sha256 "4879c27a8fc96d84793c3239a314cc3ff78f3b26ee6a3f228cddab6338bc0990"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4592cfe55942164d7064b7ba936a4fcdff041f1ac1bc8faf0b745567dd8bcfcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2629563e999ac799e9c87b37fe110b64ddc83f88ccf65f0169f3943b05dd0934"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c210f45835f48b3ff30915813aee90974461879fe69c8d56b0c4da4e63dac986"
    sha256 cellar: :any_skip_relocation, sonoma:        "7db2b9a562701e72523da9ef41b7b915d208fafba6b1bae92648429d365db1a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "095fa5e6244146140a6a4f8db2189dfbbe064227c1ffb0159b4b8bc3e24a94f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d542bc6abfc347c2f0b2d3dab8baf6b3bcc288c9a8e0a058a237504fd948b73a"
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
