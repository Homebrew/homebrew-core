class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "https://www.irif.fr/~jch/software/babel/"
  url "https://www.irif.fr/~jch/software/files/babeld-1.10.tar.gz"
  sha256 "a5f54a08322640e97399bf4d1411a34319e6e277fbb6fc4966f38a17d72a8dea"
  license "MIT"
  head "https://github.com/jech/babeld.git", branch: "master"

  livecheck do
    url "https://www.irif.fr/~jch/software/files/"
    regex(/href=.*?babeld[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d3c9af084ef57a2e4a8b2dd3c65e2f411e5b2f40a7cc53a8ad974d4b9b9445e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84bd566d6b25d9b9a5f76c444c555fba9349457f09736d033903f9fbe576babf"
    sha256 cellar: :any_skip_relocation, monterey:       "f5bd4719e5e8d62233f68e9febd680173e23a40b13c584cc15d67f60d3709194"
    sha256 cellar: :any_skip_relocation, big_sur:        "63a4e1edb9625b5f3e11df84a840979330b0bd3af8d77dec25fe09e92698719f"
    sha256 cellar: :any_skip_relocation, catalina:       "b6906565df2c7862dd7979ef3599414bc59f0b78b05b0e3a9dbf411ab29fad83"
    sha256 cellar: :any_skip_relocation, mojave:         "a59602b1643b95845ab9d1b6ecd68d1231ee825ac68fadb577e93d85b9b99ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b16202cbd6574ce354938e5e66b47efcb0b0b33e53a9b3affbce2c419efa9725"
  end

  def install
    if OS.mac?
      # LDLIBS='' fixes: ld: library not found for -lrt
      system "make", "LDLIBS=''"
    else
      system "make"
    end
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    shell_output("#{bin}/babeld -I #{testpath}/test.pid -L #{testpath}/test.log", 1)
    assert_match "kernel_setup failed", (testpath/"test.log").read
  end
end
