class FastqTools < Formula
  desc "Small utilities for working with fastq sequence files"
  homepage "https://github.com/dcjones/fastq-tools"
  url "https://github.com/dcjones/fastq-tools/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "0cd7436e81129090e707f69695682df80623b06448d95df483e572c61ddf538e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
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
