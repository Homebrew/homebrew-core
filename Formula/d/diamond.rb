class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.2.7.tar.gz"
  sha256 "e950fde217b4047e6a631e20b9c2bed602ee3dae435714cc00e6771876754422"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d5efd25d3804410df9caa7ba9a27a6304a77ef4815250e057441ff5cefc6721c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "297e1aea6f216440a9851101195977c1ccdd6409129ce884cbf8d7723b2418b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89071dbaa173dcab7013f9d6f5709ee8d0b5ecce580a3ebc30f39054f55ba762"
    sha256 cellar: :any,                 arm64_linux:       "5e509850bf50379d790416763b32c143e6e1624ec74e3be573be0eb2f1ab6678"
    sha256 cellar: :any,                 x86_64_linux:      "347e181a3fde4fa3173c40f551986c9993d51b1f79e3df1e77cd1df9affcb0b8"
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
