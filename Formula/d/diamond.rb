class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://www.wsi.uni-tuebingen.de/lehrstuehle/algorithms-in-bioinformatics/software/diamond/"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.11.tar.gz"
  sha256 "e669e74ac4a7e45d86024a6b9bfda0642fabb02a8b6ce90a2ec7fb3aeb0f8233"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16a5c9bdce286088598d1bf8922c57d953449e1bb895478ba8125f2c21c094fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd8e1083cc5a50cf7abc7c5f5e8ab9d7239e5a5403c42c9037535de188b65fb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e078aee98faa14ee3ce496ac97e5f84dc39e82948ad90e946ec4c14b1ce501ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "435817155d56ee6e7f502da9e9ac1fa04d81d6c7269d318eca6cf77f6dfed4b3"
    sha256 cellar: :any_skip_relocation, ventura:       "811f9c67db74a23b6032064103e1fa317a55fdcece0f0a07cefffe2a66469db4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a48ded9253e8c3c290481f0bb817c15b4fa11afd18b7f037fd6ed86d2133798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c1682af17f554bf337e8717692460577cbc9ee688a196133c46f9eda4ede24e"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  # fix compile issue, upstream pr ref, https://github.com/bbuchfink/diamond/pull/852
  patch do
    url "https://github.com/bbuchfink/diamond/commit/a50338f6033f55cbeb2db3526005f649a189c656.patch?full_index=1"
    sha256 "67b2998afa133a77497dc2e928af488237d5d8d419bd916df893a318470fd49b"
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
