class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.23.tar.gz"
  sha256 "ebac52b733216b6d2585fdf13e99edf5edffcc6f8c46a340a445bb03684c8726"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6548e006c2ee39452c85d7acbd888b4b664b665b05777f44b2e54646423a66a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f0f8373285d2907d2043180b487bdb34b94a8796e65097b9c5f5b47c8fa720c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54b24a1869d3ad875cae8d398f3c4e32d14d685c7ca235f09e7ba8271e33fe36"
    sha256 cellar: :any_skip_relocation, sonoma:        "69806bd545b2608766869f8873b1eb6461b34c949ebc513b346719c15c2bd0ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb1559108f988480835bd87f0015654b5b608927cd7a020c5e1f1861b7436413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b2df73c8eeb630511baababc770f358ce5ed3cd516a76d401438f9b50f5eafc"
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
