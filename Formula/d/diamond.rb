class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "35cb389dad7326515267b21a04256382853754d32b48eae6fd8a56fbb191e1c6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6be0c5e9e6eedbd68126df203f78a95b5580300e147d3e6233c6eba21ac2b5a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3d5e98b8dd0a1f5f7db15b78704580a3299f79a12240ba952f895bdf18875bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ed60e2a8113f1e55207649beb3bacc595b16f85c51a1da555c467e8dd159085"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0c0bb6dca7de16f47469c28f3f95ac2399ce3f76dba137d9c13c59063ace17d"
    sha256 cellar: :any,                 arm64_linux:   "d88d04a35ddb1df409c596115a02a5c6d9c8424b8552755a8a66f0818c2b0047"
    sha256 cellar: :any,                 x86_64_linux:  "ab638c9dece8de7f060cd760f8db94d0541f8e8fb6b2ff52d71088f1cbb41c78"
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
