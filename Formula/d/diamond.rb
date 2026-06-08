class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "36a70540039c50e4afa1d36587eb80d1a85113288c2a49731cdaaf90e3de7d02"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33d8634e253416486c0717dbf7945adeba463a3cc862d1ec2310540b8e832e70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "843466c95aa78ccbb38e76f55b4b7e922ff85885dc0652ae4f592038bfebaff9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad1648a27865a1af52fc8b5df140f6bb04d0fd7fa2c63769c9fe84b8266a5b0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "55843f6ed3b108418a3ec7d99af627eadce2a2186f18b7258842c2657a42dbe3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c87fd72d8bd8b7f17f9fb0a6bde40230a24a801dccb10514bc64d89f8f77b8f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba73eae826e76eaba1cca737dc0fe9cb7dd58a37965193871d4b9f03f2038221"
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
