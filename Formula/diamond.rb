class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://www.wsi.uni-tuebingen.de/lehrstuehle/algorithms-in-bioinformatics/software/diamond/"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "852d27c7535d53f1ce59db0625ff23ac3bf17e57f7a3b1c46c08718f77e19c54"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b519635ca0d932691bbbd697cbb4e19b1741af737bfe2ed1a081382153e1f0e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d319170f8585a8087087678aabea27e3c92593ff8be013d9c8b5a30515b6ad22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a700e3b5d6aa59840010a7c8b8b4b4db6c2b81344afce61cbfb2987b371a3438"
    sha256 cellar: :any_skip_relocation, ventura:        "e8cddfcf863ab90de09bc135dbb6a52546c0b4a4c989be3a3b2f73ee5093b205"
    sha256 cellar: :any_skip_relocation, monterey:       "d983f8e263bca45f36c4e6af61708db5e0c50f45de73f425d467a5c8ceec0a02"
    sha256 cellar: :any_skip_relocation, big_sur:        "bae352088ccce1d0836dcfcdd3d3132f50772b73b1965a76406788a50e193195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb49a335e78d6c8314e5520d763dc5c62e5be315c4f40da6a2ba8b48e937ab28"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
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
