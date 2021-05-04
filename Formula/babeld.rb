class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "https://www.irif.fr/~jch/software/babel/"
  url "https://www.irif.fr/~jch/software/files/babeld-1.10.tar.gz"
  sha256 "a5f54a08322640e97399bf4d1411a34319e6e277fbb6fc4966f38a17d72a8dea"
  license "MIT"
  head "https://github.com/jech/babeld.git"

  livecheck do
    url "https://www.irif.fr/~jch/software/files/"
    regex(/href=.*?babeld[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c6021be16309b6bb2280cb2b0518176a8940ec1925fb84653f0ecd6b5e7c8255"
    sha256 cellar: :any_skip_relocation, big_sur:       "6622356c892c502ec37f13acf4d77cf3c22b73c101da00c694419df1b41c647d"
    sha256 cellar: :any_skip_relocation, catalina:      "94f5533d9452bd84e747e2d5d37d1ca46e920490f94626d6a2bbc12cac26c0cc"
    sha256 cellar: :any_skip_relocation, mojave:        "a40446c3797cf7da4e7817513e4ee170cc48b5f5bd738bee5f7b6b50cece52ea"
  end

  def install
    on_macos do
      # LDLIBS='' fixes: ld: library not found for -lrt
      system "make", "LDLIBS=''"
    end
    on_linux do
      system "make"
    end
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    shell_output("#{bin}/babeld -I #{testpath}/test.pid -L #{testpath}/test.log", 1)
    assert_match "kernel_setup failed", (testpath/"test.log").read
  end
end
