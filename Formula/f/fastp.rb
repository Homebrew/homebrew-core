class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "42445973c57be9209c753027e99781261c69381013813c576ad447e413ff3d04"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e4b0ce35397760cb1ae41a5515cdbd6af0f0b9837cb0b9430ba47af0721b1a9b"
    sha256 cellar: :any,                 arm64_sonoma:  "e40595ad277325c483b90706f5bada72230f910059c2c0ce8be920c4ed3a3ec1"
    sha256 cellar: :any,                 arm64_ventura: "33d72eca7a0446b28c541cf6b618564cd8ed2a5d7dbe5f012a75793208085303"
    sha256 cellar: :any,                 sonoma:        "89f6f157df2b06aa301893754a21a0935a711efddfe92888ac6d45ae442db696"
    sha256 cellar: :any,                 ventura:       "5608702d4e48361821a7aa7df4b2530a62824d0d48ef9e739b9d8d2de52baa49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "329c29e311786da791929dcb3a5b0b4071f5adfcf2216f982e7eab07d74052e2"
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
    assert_predicate testpath/"out.fq", :exist?
  end
end
