class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.71.0.tar.gz"
  sha256 "236328d837d4c199c364a7f909070c86ce800b868336abb401a270bd247f9e6d"
  version_scheme 1
  head "https://github.com/boostorg/build.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "64536e5359d5a44216dfe28da70acf494e0145711ecee4cb8f014ca0fd0be3fc" => :catalina
    sha256 "38b1d0c754e3bdf870ee3eec5cd3ce5e1a6e00bef49053d75a91105b2e9311c9" => :mojave
    sha256 "54d0198ed146c01582834fdf3c399382f599b9dd94632efe0d51c1739e204ba5" => :high_sierra
    sha256 "ec8ed9608fe07c3f581bd3e67199449e80134a9f6bb718ab8e8105b3756364b1" => :sierra
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
