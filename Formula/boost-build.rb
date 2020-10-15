class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.73.0.tar.gz"
  sha256 "3490f9859a08cf46d963f0cfb834d30cd2c9f4cf5e0738dc19287b5849a316c2"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git"

  livecheck do
    url :head
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f6bb502b7848e98f4b184c2bf2604cc005e4bad599b1078a35119c2e8a2dccf1" => :catalina
    sha256 "68b1dea12cdbab911e66842020a3f66690b85612ccf539e337ed71129747ed89" => :mojave
    sha256 "2422cb690b00b75fa6dd4bfe63e7a775abd7659a537a627aec33115af051907e" => :high_sierra
  end

  conflicts_with "b2-tools", because: "both install `b2` binaries"

  # Fix Xcode 11.4 compatibility.
  # Remove with the next release.
  patch do
    url "https://github.com/boostorg/build/commit/b3a59d265929a213f02a451bb63cea75d668a4d9.patch?full_index=1"
    sha256 "04a4df38ed9c5a4346fbb50ae4ccc948a1440328beac03cb3586c8e2e241be08"
  end

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
