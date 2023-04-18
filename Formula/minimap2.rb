class Minimap2 < Formula
  desc "Versatile pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://lh3.github.io/minimap2"
  url "https://github.com/lh3/minimap2/archive/refs/tags/v2.24.tar.gz"
  sha256 "2e3264300661cf1fce6adabffe6970ec59d46f3e8150dd40fa4501ff4f6c0dbc"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e3edfa49549eacef30b1d7e2a3ff3cdaff1269fe6c7e47aae5718025d385e27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22995a1c375367bea1d8cf7c543c26eded794df72b09915e0d3858e11277dcdb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1894aa9bd2241edc817f29a5672614ab47d263529e549914df2031e14ee80017"
    sha256 cellar: :any_skip_relocation, ventura:        "0192a7524eaf07f167af3bd71bd1ffd52b26e848bbd88d0d9a52d4df97b664c2"
    sha256 cellar: :any_skip_relocation, monterey:       "66426ade59e9eb89716b9ff7d197ba45cd3dd247da46d2be4e113580ee9cfaf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9e3dbdb1a10462e980a03133b46b3be3b032f551666178b43adf204c0bd9956"
    sha256 cellar: :any_skip_relocation, catalina:       "76478e8d72e98c73004af1d6d4f2a76b6c91715e06a847b9af672edf979b55e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96c6a7109e98755e10b86f21ed922c91e34ded9f6727f90e8ffd8fc75984f267"
  end

  uses_from_macos "zlib"

  def install
    if Hardware::CPU.arm?
      system "make", "arm_neon=1", "aarch64=1"
    else
      system "make"
    end
    bin.install "minimap2"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath
    output = shell_output("#{bin}/minimap2 -a MT-human.fa MT-orang.fa 2>&1")
    assert_match "mapped 1 sequences", output
  end
end
