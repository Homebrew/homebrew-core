class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.77.0.tar.gz"
  sha256 "17ad1addbc08d1cc6ef52f7140097915bc4904c28c7d6d733c4a1a20d40bbc1c"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git"

  livecheck do
    url :stable
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b5f6010ccb4c9cf6d2ffa8f59e09ebebe54264425648f473aa8d704b0fe1120"
    sha256 cellar: :any_skip_relocation, big_sur:       "a3115a74eee73792fa4c7b2dcd025c2a254f66a87a1427b8382c77f62aac61b5"
    sha256 cellar: :any_skip_relocation, catalina:      "045128c087f35b78de73c5723385607a9a5ba061a076cd646a61f9240e6a2b50"
    sha256 cellar: :any_skip_relocation, mojave:        "37ca4bbff9b1d54b04141cc63f9fc3ccbfe3b6fc875ed66a83456600b79aed7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ee01029c5ebfa4012102049946d63357ad8c3ad08710ad7a68d74f662133ba1"
  end

  conflicts_with "b2-tools", because: "both install `b2` binaries"

  def install
    system "./bootstrap.sh"
    system "./b2", "--prefix=#{prefix}", "install"
    pkgshare.install "boost-build.jam"
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
