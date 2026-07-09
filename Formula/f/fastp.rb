class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "4a282e9bbcbce849cd4ed3527e59469ad2cf7cf8d3cbe99debabaca985030946"
  license "MIT"
  head "https://github.com/OpenGene/fastp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1685662000bd184abe5e274ec8aa355a03890ede9f9a0b8a280390c9fbe9c009"
    sha256 cellar: :any, arm64_sequoia: "797768d8868a4043d250ce81f681ceac27e749cce81441b65f927db34d845ddd"
    sha256 cellar: :any, arm64_sonoma:  "9a8b67b288f51a3d922983a02c3edea3dd96445fd1e691995db59de5319310a8"
    sha256 cellar: :any, sonoma:        "e9ddab50814c79ef775bb2b434fe041e6f1f919d1cd14384a680a7d7ff349636"
    sha256 cellar: :any, arm64_linux:   "982fa1d19a7b307e34c37b2dde1c475d3d4096f15fcdcc991f1e127ee2b0eaf0"
    sha256 cellar: :any, x86_64_linux:  "85d747cea64b1a7d52a9a5d1a3b54389928f2122fcb011276ec82d578236d079"
  end

  depends_on "highway"
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
