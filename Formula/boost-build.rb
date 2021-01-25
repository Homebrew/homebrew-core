class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.75.0.tar.gz"
  sha256 "889e931b25e435912e7b0dda89ae150fa1dabe419caccfbb923d41e85809e7df"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git"

  livecheck do
    url :head
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "3e55b292a1bb2162a3ac207897e0c38031dc65a4bd858c085ffb35dfeae8237e" => :big_sur
    sha256 "050492679c4ceafce723aca7fa4185e1342e3cd011b1947f33466e639ece226a" => :arm64_big_sur
    sha256 "71b77320b7c991c74dbad21e38e875cb2b150db8fcd56113d3f74ea379343b6f" => :catalina
    sha256 "ef91e139803aba94c3ce22e085d1332b78e1a820fdeb73dace0eebc194aec0a4" => :mojave
  end

  conflicts_with "b2-tools", because: "both install `b2` binaries"

  # Fix build system issues on Apple silicon. This change has aleady
  # been merged upstream, remove this patch once it lands in a release.
  patch do
    url "https://github.com/boostorg/build/commit/456be0b7ecca065fbccf380c2f51e0985e608ba0.patch?full_index=1"
    sha256 "e7a78145452fc145ea5d6e5f61e72df7dcab3a6eebb2cade6b4cfae815687f3a"
  end

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
