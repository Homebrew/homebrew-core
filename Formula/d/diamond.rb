class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://www.wsi.uni-tuebingen.de/lehrstuehle/algorithms-in-bioinformatics/software/diamond/"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.10.tar.gz"
  sha256 "c6ede5df30d9d496af314e740964c35a0e358458d9c8d9b8dd517d69828d9981"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f8557081c35b772cee8de8e2751f03097a47e8293d57026329b06f09128a1a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e8dc8ece677609259392d2e5c818ca3330eb30290baa043b946ba68eb7c73f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81ff44a3ae176084f63ad0395203b6711061804eef5c5ecec98ee1050e3daf46"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5d57d55a193ed25775b6d3798d47e6201ba6514b1b496296aae4b0f9786b0eb"
    sha256 cellar: :any_skip_relocation, ventura:       "3e12a967c882d12655033b9dab86a70329b2f260b6dbc26d49aba9fdde02441c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11a1e9d0e3831b31f7f0ddb66fd73d85a35cc82018d5344680f7eedda772b190"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

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
