class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://www.wsi.uni-tuebingen.de/lehrstuehle/algorithms-in-bioinformatics/software/diamond/"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "77e9ea5ca2eb01efa391970d6adad417cf3302ffac403cba638168938fe1befc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "048afe8f4aaedf2edcdf7556e86852d2a2bf9e422392d8b230ead2ab7eb3deb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c06489c1429f6d0f9f5173e95c0a77d687f3838fd94eecdf84cf80656bb2e845"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05dec99fd645fc14cda1a65cecea093ede97133a24d07cccb648f59b2f3b25fd"
    sha256 cellar: :any_skip_relocation, ventura:        "b30bbf94c2bad84051a4d197b75f1606b593eb8857296046d804c8b2d4e37c79"
    sha256 cellar: :any_skip_relocation, monterey:       "974aa226a4dbc2ba46e57e9ec130b653c07f5481298714d8bacb690ebeb93024"
    sha256 cellar: :any_skip_relocation, big_sur:        "aac71eae2009f881062264cad63e9f974891aed2bec7cac55524ad498968de17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "391842f8269f62f3113a42e7b2ad3be5683228a5cd2d85e11ec1408de985667e"
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
