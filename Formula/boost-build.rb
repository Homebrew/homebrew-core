class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.71.0.tar.gz"
  sha256 "236328d837d4c199c364a7f909070c86ce800b868336abb401a270bd247f9e6d"
  version_scheme 1
  head "https://github.com/boostorg/build.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "93420480adf7f1cf9841208e83b64e8922570615a05b660434e68518d05fab54" => :mojave
    sha256 "aa655c94582d43d4dcbe9f8262a9a268b90d602cd26c381fd8946c238c0a277a" => :high_sierra
    sha256 "6e152f2e37d06260b92c4d4d6c18ccbe8027df0397c4e0a524301ad6159c916b" => :sierra
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
