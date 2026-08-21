class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "ca58297af1c60e02a36363f11d161a27f5bd4fed8b172cc56fab65805f37056a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1255b9f27c9f87000599ea7ceee4d64fcc9401874ad04297a05d9553bed409fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c8a434d34152fc04089fa4c6aa7fdae15e8d91240c597cbb281560aa8bb33fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a45392c28552ebd05a544548a8eeefb3c810c43d30c9e314cbb82f502091fb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "344cfb21d113f06ee1e387b110c23bd063ede1991763953aa1d3ee3fc6489e58"
    sha256 cellar: :any,                 arm64_linux:   "25a7ca6adb1a16788e22735cbf7ad4f334ed9b92a3276fe54d4c3b0e747e6bd1"
    sha256 cellar: :any,                 x86_64_linux:  "54ea8a2639a3c8be8f0908ec5a2d09ad9b3aeb3b31ac9fc6269fab385f3ddcd7"
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
