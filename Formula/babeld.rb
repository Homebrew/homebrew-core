class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "https://www.irif.fr/~jch/software/babel/"
  url "https://www.irif.fr/~jch/software/files/babeld-1.12.2.tar.gz"
  sha256 "1db22b6193070ea2450a1ab51196fd72f58a1329f780cb0388e2e4b2e7768cbb"
  license "MIT"
  head "https://github.com/jech/babeld.git", branch: "master"

  livecheck do
    url "https://www.irif.fr/~jch/software/files/"
    regex(/href=.*?babeld[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e68584ae72520a7d61fe856321ca107919fbd282a6d769b8ea30902cfea75ffd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a0ee55f54d543d757d8ae2d51918bf91b06adadf20bf6e07cf2f3ba37ee25a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2440f56ff2b32e9a92797e38e8bebe1286054c9bb6b1a130dddbc71964056f81"
    sha256 cellar: :any_skip_relocation, ventura:        "3264ab5bbd4676d4e672747ced0f7a6cb2096f279b0ba66c100a3d8c17276543"
    sha256 cellar: :any_skip_relocation, monterey:       "e83652d57f1caf5167a855643d938d65f40408f2b6da1a0c05dc33eac213edc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "39d1dec915ef36e583c975cfbec75cbeec0b0ee00e56f08330eee960f60b7b2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91e8791ee9a601b6d8ee202a6b4e21baedcdbbb8c95fd5cf007ad0895a39c68d"
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
