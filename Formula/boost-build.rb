class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.76.0.tar.gz"
  sha256 "886bc799c4a7c56218a41acee89f37073672c5c02586b680bf6dc0603d6c9349"
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
    release = nil
    on_macos do
      release = "darwin-*"
    end
    on_linux do
      version = IO.popen("gcc -dumpversion").read.chomp
      release = "gcc-#{version}"
    end
    out = Dir["bin/#{release}/release/hello"]
    assert out.length == 1
    assert_predicate testpath/out[0], :exist?
    assert_equal "Hello world", shell_output(out[0])
  end
end
