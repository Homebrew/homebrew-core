class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.72.0.tar.gz"
  sha256 "657d175aa59bcb307f75990fe2ae43793d30e40540c6d964b96ab5db3aa8629c"
  revision 1
  version_scheme 1
  head "https://github.com/boostorg/build.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b6a968f112d3cd808c4ed9186e4ee7f45fbf1adf19c188d65d782976c4f7bd0" => :catalina
    sha256 "60041cac36e864d8c0296101f5ed5137f2c09413c0f054b87ed5c9ed1ad3e65e" => :mojave
    sha256 "ea884fe791ba6b1b336d4bffdbba02414dbb746199c2748f0aefee845b7fbcd7" => :high_sierra
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
