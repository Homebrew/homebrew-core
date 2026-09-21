class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v1.3.7.tar.gz"
  sha256 "5b7d6880c66e9e10e5923c68ee0c0b5a30f59bd252d836c379c74f8533c26993"
  license "MIT"
  head "https://github.com/OpenGene/fastp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "acd2832590efd030f0fd0764cee27553aba205c6bd2b6e540e4fd1674b2d3e3a"
    sha256 cellar: :any, arm64_tahoe:       "9a75066f6e239aa91017d62874994d00ab66ae9487eaa5066988bc1800b2685d"
    sha256 cellar: :any, arm64_sequoia:     "14a607e1a05c18d790377fc352545916bfdadc75041941d6b314aa55fae16d8f"
    sha256 cellar: :any, arm64_sonoma:      "2e0425d920e6ca121d5146f78af218eec80ebf81120faaea11637b43d822cd1e"
    sha256 cellar: :any, arm64_linux:       "27cdb26d7affb30e515d370d636755a045f1a59b4e25baef746e1dc08155dba1"
    sha256 cellar: :any, x86_64_linux:      "a08e628afdab698fe9e6e85b9edbd535b7986572f7aff76a2db7b96c48801aa1"
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
