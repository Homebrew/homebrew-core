class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.1.18.tar.gz"
  sha256 "aeae3a5f20bc8770b08ae14e563c8e86f26886b238492b43cd91218ebe891f46"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f359132ef2c414a56d6ea6683da82da8121837289cac5132c9354297653b6b56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e6d7dbbae843a1ee9cf876c009e0c14b0ecfd8c17c4f738760ae432880166c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32d39c0c3ec840eeff1e328cbc043870c09a41ac2b8fd77d67e64cd4bc9fe8ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5a02a6440ac029fd6f09b8990cec6048472cbd96a103367744a4611ce4d5740"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d021d3ee4e6050bc3b28cc895515dbba9928b934b9ab3e26916990f80b2c05cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed725a54c57fee429d4900b019331796d1cd62406be07fafaa1a55036bbb0274"
  end

  depends_on "cmake" => :build

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  # Fixes building with Clang 17+
  # Upstream PR ref: https://github.com/bbuchfink/diamond/pull/921
  patch do
    url "https://github.com/bbuchfink/diamond/commit/72b78f6b994984602f650fe664d5f83ea15b24b6.patch?full_index=1"
    sha256 "606ffcfc8f68d6a043a0b2a48e3e93a68463017490da9e7be0c9782f825e3ee1"
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
