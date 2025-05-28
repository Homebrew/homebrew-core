class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v0.24.2.tar.gz"
  sha256 "10160116770e161cffcfd0848638dcf1190fa7c9cf7e84bf7c4051e8f8dd9645"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "23ffe05e0baa375fcde060cd8f4a686577da6201e62a4a69dd756ff832b7d86a"
    sha256 cellar: :any,                 arm64_sonoma:  "9a5119aaf811d6a0edf99d5cc8f4de6de179f73d0d67a3465671ce979792dfab"
    sha256 cellar: :any,                 arm64_ventura: "3f39caa2a80acb0f9b8126779ddd192aa457441029b3cfee50aff7b6f40aca50"
    sha256 cellar: :any,                 sonoma:        "e061b05495e5a5621c387e6fd81ec8331eccec22eadb38d20ffd5452f17a4213"
    sha256 cellar: :any,                 ventura:       "fd88ca083183a47d715adc8921a70cf639e0f7b3a202e02a54c6c79a6eb9a795"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5d0193fc1ac731476b650f07c9574dc4b9911da6ab66bf5270a3a12d1032dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c34bed447c51cb1c02fb073b58aa956191eeefcc2ad234f94c63048874c63fd3"
  end

  depends_on "isa-l"
  depends_on "libdeflate"

  def install
    mkdir prefix/"bin"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "testdata"
  end

  test do
    system bin/"fastp", "-i", pkgshare/"testdata/R1.fq", "-o", "out.fq"
    assert_path_exists testpath/"out.fq"
  end
end
