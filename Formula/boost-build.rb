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
    sha256 "a8391d8d237ba58ad70c524b21c0d9d3aef5c05b8e9b824e1a326f1d7b4785cd" => :big_sur
    sha256 "1ff4602f5d80ab3129f451f6316fd9517503f88218eec48eb63cb244581e6ea0" => :arm64_big_sur
    sha256 "7ed06c86c4b86828bda71d03665c4464dd76603b68a6f8cd0199afed2bf749c1" => :catalina
    sha256 "23bc63e542ec5835f2450fbb0d472c4b0c2426759cb12ac2f0e7564a706193ca" => :mojave
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
    out = Dir["bin/darwin-*/release/hello"]
    assert out.length == 1
    assert_predicate testpath/out[0], :exist?
    assert_equal "Hello world", shell_output(out[0])
  end
end
