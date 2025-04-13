class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "42445973c57be9209c753027e99781261c69381013813c576ad447e413ff3d04"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0b1857b6a337f7867d9d6aa0bb35d7698c9eef52b6055ef9d5c9a272d4cd10e6"
    sha256 cellar: :any,                 arm64_sonoma:  "cbabdac6b39972a39ed5182be994809d66e06019e6f868ef1414ca6dc7e85554"
    sha256 cellar: :any,                 arm64_ventura: "2db312fadbe52246448cc481e9a497e1a88c233b369e3fb4e57274451167d4ca"
    sha256 cellar: :any,                 sonoma:        "edf65bd19025373896ee67537cf40753cb29eff691192e06b5ef1db0d07744ad"
    sha256 cellar: :any,                 ventura:       "5fe76051073d69ce846aed31f01cceae1c32fdaf329b9ca2feec825434c6fd79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bb59d6348fab36c97b7f9bcb50134a593623f179ee8e45661001fe5ebb1ab1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a58d8f99ec2c14988a9ee2351feae042053d7d5e3e8266b8b9dda439f2172bbb"
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
