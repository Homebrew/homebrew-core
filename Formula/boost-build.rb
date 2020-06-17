class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.73.0.tar.gz"
  sha256 "3490f9859a08cf46d963f0cfb834d30cd2c9f4cf5e0738dc19287b5849a316c2"
  version_scheme 1
  head "https://github.com/boostorg/build.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9258aaeba7c8db8830f549cc749f31a4d4ee1f9c46f584a8057e791637fa311" => :catalina
    sha256 "5a35c7f4eaaef0b6644dda7947d14fe429a12d26df4c755efed6bc11846dbded" => :mojave
    sha256 "17cfb3cc8324a77ebc6f34091744c8e2e32e50c17c577a87159285c21c061c5c" => :high_sierra
  end

  conflicts_with "b2-tools", :because => "both install `b2` binaries"

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
