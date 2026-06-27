class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "9c1f6c1cc48c93381071de7cd5ccca5d975cfa2c44985885894ab89f7236ea7d"
  license "MIT"
  head "https://github.com/OpenGene/fastp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eb92644386ecd98bfd17f63b2d54f783020fdfed825813043f8421bb4fe88a95"
    sha256 cellar: :any, arm64_sequoia: "032d89f733fa2f75e3a2e04336793fa37a8d46fe62b035401b42015f6fc9da91"
    sha256 cellar: :any, arm64_sonoma:  "a055b670f4980fe512b586b2046c8ca87f768fd7dcb1af12adf8e5e4af68be90"
    sha256 cellar: :any, sonoma:        "46a7cf38d373fd6530e5da1af6fb73f4855c3217cdcd075bddc4acbb8267461d"
    sha256 cellar: :any, arm64_linux:   "74f5f56929aee4af1452187409065ce64be8c0888eb55aef8a7fac460ff65093"
    sha256 cellar: :any, x86_64_linux:  "c025a64a84ee33f7cab14ee1b307bacc4e7faa8f25d76602b7907de6867a69a2"
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
