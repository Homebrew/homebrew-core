class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.19.tar.gz"
  sha256 "245436374e4f0f025465a686963852492a0d036a58f01185b7ec9eed145cc347"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a1d8c9732dc52187440e85725a0ea960cadbfdea78249442998b5e966edf868"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f81e2bab087b9f70495dd919e1969666e2f20c9c85382a3ba0d1023bfb1c0ba3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e9b6c4c566be9e2cd9e8157ccb9703d79a6859f82b699221761670f386dc352"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d8978d294a6b3038687814241fa772023a21013b28a2582d65ca93d6084f8af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eac1237f75d0e97d5c56d29b14586809650881928d47ab553d16892871b9874c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf11aebb85eab528a416d2d40751f3f1511652fc1279a64d2e40b85aee9902d3"
  end

  depends_on "cmake" => :build

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

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
