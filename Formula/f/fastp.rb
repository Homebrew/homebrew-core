class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "ef0b265e6130b0f7d56d713399ae63980d2b937d6f9df8e458a3ee578d59a97c"
  license "MIT"
  head "https://github.com/OpenGene/fastp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b2900c616a31ca11f6aafab782aa101a2b0b0f72066158e3c3add5649ed29ec"
    sha256 cellar: :any,                 arm64_sequoia: "eedfd18cc5dee8ee10060e6551bc4174a0233f590991a8dc13cde2d9f473796e"
    sha256 cellar: :any,                 arm64_sonoma:  "69f008bc9234af3cf4c6ae08e3be75132c875576d5d3bcd219ebba12dd8047b6"
    sha256 cellar: :any,                 sonoma:        "27a844481a18635e904fe7f028e5fa73f1505da4a36bd3331cbd2d8aed88d4e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e10910cd72defe0628be9202de20cb9171b0b47a8969dc34eac56231939057ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3592585f2806a95daf1a6aeeb891eb2556dbe5cd01236fd0f64140b80a53efdf"
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
