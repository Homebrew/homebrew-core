class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "6199f96b294adcc2f4fde72deaa5757cb5b4ab4657c0d84c866047a70031742e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0678f0516f6bfc6d23d92ca560bb45d467a4211ad0bb920ffcb7fc13a11383dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9701cebf59db03bea7fac66a028eeced02cba1c969daa2475ec01453896dd7bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a25b7f660fa2c78a39dd995d5692158a9b2894ed788fd1c4d846396885b894c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfae017007b195ee163fa54e337582d1eae37037d058128cc677742b13018aaa"
    sha256 cellar: :any,                 arm64_linux:   "4b3ee1bba95de7bbcec0f7730d5c0883a9e48fce77d7bdc857bc7db028d1f872"
    sha256 cellar: :any,                 x86_64_linux:  "a3410a33af3a8603a0e32e272035f04794a96c5f5751d367fdba89b6e76154e8"
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
