class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "11c593677b67ef541095122c243eed384bb9933da12fffc676ad7b35a3e4dc44"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad039ed2e36bccb1f0b4627d556e0f1d7a00ba7fc4d47485f1ea1ea5854155a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce985ffe27a8da4bf49a7b5b3dd0662a1a3df92e213d115922045f04358e39db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27ea71d3ceaa0ca22637bf13e5f03dd7a92d735dac8cfc8f16d59604363c93d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c947f8078c1d09f72461ad0406438d924359bbbe25f1668f1f3d2426457a31c"
    sha256 cellar: :any,                 arm64_linux:   "186b123f698642bfaa2cb0e586f26fb1fb48a8cfc7f374b53b1d9ae005c7fb82"
    sha256 cellar: :any,                 x86_64_linux:  "9132e6abb98a3dbef983ce08def7eeaed19354434fab84883db7981e2c70ec1d"
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
