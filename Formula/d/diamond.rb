class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.16.tar.gz"
  sha256 "bdbe7264ea64c29745af83a011345f6fa4b9a5c98e89fbaaba3f04e088f821a8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfddc0a39ea401d0ed0da7be65da52ac27aa05f71b93f6a2a4c70137f0519c06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56008cf521601f21b1a2a286fcf8bf4da5f01caf713e442b8bd8b3c4c816f530"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c58b437b60f37bdecaeaff8e818b89234dd5e7e236c0d45578897299f57eab72"
    sha256 cellar: :any_skip_relocation, sonoma:        "252e823a7bae4101629067123df9232a4a7e93b65a2f651ae9d0e7669114220f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a767c368f68b5b5277f59624362258185c138e8a95997f3fd76c7ff30698596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebc481813d0e3096025456527c8e04171454acd89af707deebc364d17c9e15bd"
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
