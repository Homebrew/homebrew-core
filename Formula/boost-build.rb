class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.69.0.tar.gz"
  sha256 "493ec35e45ba5c0b8f839259672c375c182c13a9f94dacd2e2de85043b081ea4"
  version_scheme 1
  head "https://github.com/boostorg/build.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "968fdb513f199d9ff96f59369339c8f06ffe53262dbfd24579d19e67eb5cceaf" => :mojave
    sha256 "2ad7e180a9526558f89b889a26c41c8b63745da4f4486abe2334947ff69950d3" => :high_sierra
    sha256 "700eb1116d61b9025fcdffa4f995054facd97d4149144d96d5a41306dd23be1c" => :sierra
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
