class Lastz < Formula
  desc "Pairwise aligner for DNA sequences"
  homepage "https://lastz.github.io/lastz/"
  url "https://github.com/lastz/lastz/archive/refs/tags/1.04.60.tar.gz"
  sha256 "e66bb419a6599861b1d48c3b209d3746e8008c3ddde33f0dfeaa76e634bccebf"
  license "MIT"
  head "https://github.com/lastz/lastz.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f4c8f155a9acf8235de2895131fc62edc512a4eac70093b40b9a6c91c3b7e429"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5112434c1872194d7e547c566850e281a442e0b23c7a9aa706c04ec7f634b3ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9017e525dffe2a755d1b87255861861e33a3e8ac1b9dfc5d18d89a96b06aeb21"
    sha256 cellar: :any,                 arm64_linux:       "1e118efabd4ee045fe260dee31976d2f7b9e47548d75e74b9a3d523421706297"
    sha256 cellar: :any,                 x86_64_linux:      "f7f49c33dfcc3524952bf011dd539c764d296a1a428e1050f426562e2d5c1663"
  end

  def install
    system "make", "install", "definedForAll=-Wall", "LASTZ_INSTALL=#{bin}"
    doc.install "README.lastz.html"
    pkgshare.install "test_data", "tools"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lastz --version", 1)
    assert_match "MAF", shell_output("#{bin}/lastz --help=formats", 1)
    dir = pkgshare/"test_data"
    assert_match "#:lav", shell_output("#{bin}/lastz #{dir}/pseudocat.fa #{dir}/pseudopig.fa")
  end
end
