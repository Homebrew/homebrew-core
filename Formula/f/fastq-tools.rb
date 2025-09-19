class FastqTools < Formula
  desc "Small utilities for working with fastq sequence files"
  homepage "https://github.com/dcjones/fastq-tools"
  url "https://github.com/dcjones/fastq-tools/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "0cd7436e81129090e707f69695682df80623b06448d95df483e572c61ddf538e"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "f57dd1230850ef71d77be3507a7b7067f4d0a22eb574fffc98c1f5fe1a62bbe4"
    sha256 cellar: :any,                 arm64_sequoia:  "676774cb2b0ed5421d985f2e97120b61d9b0e376b21ca90415bf6e25ba98407a"
    sha256 cellar: :any,                 arm64_sonoma:   "f790be169a1f463a9e0dcc3993d4d7d5071da117bb1b370777af61212bb42bdd"
    sha256 cellar: :any,                 arm64_ventura:  "edcf84aaac94da45c90a5a300ad484b6e958cd59878970d8a60dd679e0f89949"
    sha256 cellar: :any,                 arm64_monterey: "8580b8ff6e5de04a060b60b5251d01fad27a25c8c4e1b1afdc9534e9ae445cdc"
    sha256 cellar: :any,                 arm64_big_sur:  "ac48791014e14979ad786e59178d0b468510d02f5d51a86608b388adad4405f1"
    sha256 cellar: :any,                 sonoma:         "4e0e4080fa409044a22ab8aa950634cc040b66e17cdc7019409a2b559738709a"
    sha256 cellar: :any,                 ventura:        "a69e35ad7cc93c6481de5b86c4482200ce80e417472c77ae1eae5d0bf98c22ab"
    sha256 cellar: :any,                 monterey:       "0ead212cb078edbf77f9e58d4186dd4aac103fadd8291c6bc328312cf6383b4c"
    sha256 cellar: :any,                 big_sur:        "18f3e795ec5c2c182bfc995ce662816cf17ccbd719fef30937f5456d28bbccc5"
    sha256 cellar: :any,                 catalina:       "20105d6a89abbf493ceeedfc29a956b9b4cc90bf2843cf73e544b03c0456b0ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6705cf6567e0d7c7f8fcb8af52cfc0bd8dcf62b6ad61339ed00433fbeb2f16d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abd98e72c698e16a077443d29259f946f7ac36c6e5f5a6e172be5466c4cbf2cd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre"

  def install
    system "./autogen.sh"

    # Fix compile with newer Clang
    # upstream bug report, https://github.com/dcjones/fastq-tools/issues/32
    if DevelopmentTools.clang_build_version >= 1403
      inreplace "configure" do |s|
        s.sub! "-Wall", "-Wall -Wno-implicit-function-declaration"
      end
    end

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.fq").write <<~EOS
      @U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
      +
      IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII0000000000
    EOS

    assert_match "A\t20", shell_output("#{bin}/fastq-kmers test.fq")
    assert_match "1 copies", shell_output("#{bin}/fastq-uniq test.fq")
  end
end
