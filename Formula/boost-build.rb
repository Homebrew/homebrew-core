class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/refs/tags/boost-1.82.0.tar.gz"
  sha256 "34a99b0287a25b96460c78f89f29d6e6ba869c444eda8697dbcb8a7ea9ff6c86"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cb3bddfbcf340f3c10e953a79d8e7866f7d14e1f49f9ee5613e4a32e406031d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8593e39c554a72af96f8c8f55f86ef042b9f53c78beab4912b82bb26acc73f7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba944be9122cc25bc9f381dafcdb822a845d391b33e77843fb96566b75d8af94"
    sha256 cellar: :any_skip_relocation, ventura:        "ab83d8d3e372d41c366b11e868972d432d7edbb4983510a7b0079b7dd7d2840f"
    sha256 cellar: :any_skip_relocation, monterey:       "c8bd4dc1776ec74fbdc18587770e90d3d97954b95f7ba558e3c7c05e353cf7d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ab50110a3d3d0bf8c836484ee36c9967fd88000113ace82b29c69c934d9a4f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e7f8a222ac15f549aaebc1886a13c543754b9a66c29931627015047b8afa5ca"
  end

  conflicts_with "b2-tools", because: "both install `b2` binaries"

  def install
    system "./bootstrap.sh"
    system "./b2", "--prefix=#{prefix}", "install"
  end

  test do
    (testpath/"hello.cpp").write <<~EOS
      #include <iostream>
      int main (void) { std::cout << "Hello world"; }
    EOS
    (testpath/"Jamroot.jam").write("exe hello : hello.cpp ;")

    system bin/"b2", "release"

    compiler = File.basename(ENV.cc)
    out = Dir["bin/#{compiler}*/release/hello"]
    assert out.length == 1
    assert_predicate testpath/out[0], :exist?
    assert_equal "Hello world", shell_output(out[0])
  end
end
