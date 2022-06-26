class FastqTools < Formula
  desc "Small utilities for working with fastq sequence files"
  homepage "https://github.com/dcjones/fastq-tools"
  url "https://github.com/dcjones/fastq-tools/archive/v0.8.3.tar.gz"
  sha256 "0cd7436e81129090e707f69695682df80623b06448d95df483e572c61ddf538e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8580b8ff6e5de04a060b60b5251d01fad27a25c8c4e1b1afdc9534e9ae445cdc"
    sha256 cellar: :any,                 arm64_big_sur:  "ac48791014e14979ad786e59178d0b468510d02f5d51a86608b388adad4405f1"
    sha256 cellar: :any,                 monterey:       "0ead212cb078edbf77f9e58d4186dd4aac103fadd8291c6bc328312cf6383b4c"
    sha256 cellar: :any,                 big_sur:        "18f3e795ec5c2c182bfc995ce662816cf17ccbd719fef30937f5456d28bbccc5"
    sha256 cellar: :any,                 catalina:       "20105d6a89abbf493ceeedfc29a956b9b4cc90bf2843cf73e544b03c0456b0ad"
    sha256 cellar: :any,                 mojave:         "adf7e00692719889bdaee28870700857b9e1b0ec096b62f48e76eac5ac27f52c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abd98e72c698e16a077443d29259f946f7ac36c6e5f5a6e172be5466c4cbf2cd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
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
