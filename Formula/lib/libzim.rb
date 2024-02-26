class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.1.0.tar.gz"
  sha256 "faf19a35882415212d46a51aab45692ccfa1e2e36beb7261eec1ec53e29b9e6a"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "5087b021b50ecde3ed33f1aaed8282d15d1df85c83bae07d50e9842af3719484"
    sha256 cellar: :any, arm64_ventura:  "8c6c69a23bc4c4b11460f31bcce6b4b41177c3135afc53cf6ce7188a933944f5"
    sha256 cellar: :any, arm64_monterey: "f92afea7ba737136301a3923fae81f9c220c951de4cacf4522b0789013715938"
    sha256 cellar: :any, sonoma:         "317740472cbf2a0aed059791be02d10a453e34bfd94a1c07d335a766675c0120"
    sha256 cellar: :any, ventura:        "00c2de5a5d129c1b1d36eeeb241a31d20a3aab8f1842bab60870940b63bf2773"
    sha256 cellar: :any, monterey:       "b62bda5ca687eb39b7180668ed7492f37a655b08be803f4440cfde8570a1fc39"
    sha256               x86_64_linux:   "b183d2be9d872a7f8c3159cf5442e8fe73acfdcbc68a863394133e85cd3adb9d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "icu4c"
  depends_on "xapian"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "python" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <zim/version.h>
      int main(void) {
        zim::printVersions(); // first line should print "libzim <version>"
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzim", "-o", "test", "-std=c++11"

    # Assert the first line of output contains "libzim <version>"
    assert_match "libzim #{version}", shell_output("./test")
  end
end
