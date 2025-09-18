class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.14.tar.gz"
  sha256 "b15407ec06508dd71afbdb69da47a0983b9926e4b7f4591b0f3a13e64b38a536"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c8bfe5976d60ef458feee057f10a0b2cfd795a0cc585b15fb60c96613f2715d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92e2f74cb79f83660f0cda26dfeb34bc2744ff448656c624491d167998b2bd35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29f969181a01d9221bd1fc6c3b81c96ae153904d9513c67c1b28c1c3b69e80ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3cb306f67220c2fc2c9595a1f6aa4aa1f98c3fe866e0e1dc83109abdde5f201"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e34321a92f7a5880e5d3a78d6247fb9a84e261502c7fffc7a4e87cf848587aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6862444e39956627ce010040a69350c575b6a8b8699bf04c7d43de558df852f5"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    # Fix to error: no member named 'uncaught_exception' in namespace 'std'; did you mean 'uncaught_exceptions'?
    if DevelopmentTools.clang_build_version >= 1700
      inreplace "src/util/log_stream.h",
                "!std::uncaught_exception()",
                "std::uncaught_exceptions() == 0"
    end

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
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
