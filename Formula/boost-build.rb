class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.66.0.tar.gz"
  sha256 "f5ae37542edf1fba10356532d9a1e7615db370d717405557d6d01d2ff5903433"
  version_scheme 1
  head "https://github.com/boostorg/build.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6aed1a3d7dce1feefece8ea984967278da732fbe23292aca844cdd8c847bf63b" => :high_sierra
    sha256 "87c0d16831b948b198795c2d17b96d8d7a586c0775411c4b3097266fef09e52f" => :sierra
    sha256 "da756b55ac249c474a875ee4d2c57a49ec7331b08ee006cba5b2477883dbffee" => :el_capitan
    sha256 "59dfa2358b532c384a8ff452be4c09d7d4e085f3a0be8c3f859c60ff55830905" => :yosemite
  end

  conflicts_with "b2-tools", :because => "both install `b2` binaries"

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
    out = Dir["bin/darwin-*/release/hello"]
    assert out.length == 1
    assert_predicate testpath/out[0], :exist?
    assert_equal "Hello world", shell_output(out[0])
  end
end
