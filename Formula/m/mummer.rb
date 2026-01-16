class Mummer < Formula
  desc "Genome alignment tool"
  homepage "https://github.com/mummer4/mummer"
  url "https://github.com/mummer4/mummer/releases/download/v4.0.1/mummer-4.0.1.tar.gz"
  sha256 "bc20ae2701a0b2e323e4e515b7cfa18a0f0cb34a4ff5844b289b2de0154e3d3e"
  license "Artistic-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ea0c12fffc202ecffba587be17af6930099814e91deed4a211e8a61b0bba6813"
    sha256 cellar: :any,                 arm64_sequoia: "4ef96b830de6516a971c825d97a1de9b020f6fd2e6fd8a61fc3ed3529ac03ea9"
    sha256 cellar: :any,                 arm64_sonoma:  "0850acd96974b0be3972f4869f021f275bb13c745febb4c3dca281b4aaf34042"
    sha256 cellar: :any,                 arm64_ventura: "34d55037263abf3c69c4c78620f5e8a43edae45192938be22744bc5b81326b60"
    sha256 cellar: :any,                 sonoma:        "b3d22a6054a15ec85880b9f3880f1404d6d49a945d6a98fd62ba2e47dd33d2ab"
    sha256 cellar: :any,                 ventura:       "717f648282b990e25757252a3acc3be4ba1dcaf1f8600913f6fcae8ed92af3b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a813872082d1721022174b82f6d53e954779f204cb15a706dc9698b1b8b41324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d131ccce92a6642ca9ede2ddf4097dd88a48b96748a9a64724fdc9e509b049bc"
  end

  on_macos do
    depends_on "gcc"
  end

  conflicts_with "gd", because: "both install `annotate` binaries"

  fails_with :clang do
    cause <<~CAUSE
      Clang+libstdc++ seem to have issues:
        * the unittest for multi-threaded output fails
        * tools using multi-threaded output have incomplete and inconsistent output
    CAUSE
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    # Align two small sequences with nucmer
    (testpath/"seq1.fa").write <<~SEQ1
      >101
      ggtttatgcgctgttatgtctatggacaaaaaggctacgagaaactgtagccccgttcgctcggacccgcgtcattcgtcggcccagctctacccg
    SEQ1
    (testpath/"seq2.fa").write <<~SEQ2
      >21
      ggtttatgcgctgttttgtctatggaaaaaaggctacgagaaactgtagccccgttcgctcggtacccgcgtcattcgtcggcccatctctacccg
    SEQ2
    cmdline = [bin/"nucmer", "--sam-long", testpath/"output.sam", "-l", "10", "seq1.fa", "seq2.fa"]
    result = <<~RESULT
      @HD\tVN:1.4\tSO:unsorted
      @SQ\tSN:101\tLN:96
      @PG\tID:nucmer\tPN:nucmer\tVN:#{version}\tCL:"#{cmdline.join(" ")}"
      21\t0\t101\t1\t30\t26M1D37M1I32M\t*\t0\t0\tggtttatgcgctgttttgtctatggaaaaaaggctacgagaaactgtagccccgttcgctcggtacccgcgtcattcgtcggcccatctctacccg\t*\tNM:i:4\tMD:Z:15a10^c59g9
    RESULT

    system(*cmdline)
    assert_equal result, (testpath/"output.sam").read
  end
end
