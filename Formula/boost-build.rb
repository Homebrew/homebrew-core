class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.67.0.tar.gz"
  sha256 "0deac13cd1c811b6336456288dcb401a59d367ea68429a97f39f2b0bd65a61f8"
  version_scheme 1
  head "https://github.com/boostorg/build.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "632210e339a03240347ab9e57b35220d0f0c3a6222b68d65f6eda7134fcb15c0" => :mojave
    sha256 "d95eb10205664a7cf1c6acad39fbb90cb4510bc8a8d55466c20094f50f1a9ed4" => :high_sierra
    sha256 "ce84cea580da009b087e31b1de52add90798d4daa9b90222211069f90f1edecf" => :sierra
    sha256 "d16363f1e6d300e3a082fa62a16b6241dc3297ed092c14c6ffb06bbfdf1d241a" => :el_capitan
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
