class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.2.2.tar.gz"
  sha256 "458d89638606eeabaad5098b0ede7a76396cbcb6c13fb2413afee601b5c1e0c6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f83fd067641489425d3fa3ae7f3cf2a627696a5541fa3ffa1ac572371af9e4b2"
    sha256 cellar: :any, arm64_ventura:  "42621239e15d98381be121547ae72a934002803960b24e0024389dee5a47483c"
    sha256 cellar: :any, arm64_monterey: "da7e67709552664de6c396e147ce17856a6e016f0f44c4e12e5d329c6cd0b3ef"
    sha256 cellar: :any, sonoma:         "4a71785c0b0f098e415e15a8459e60c39303fc8483d6020670761e51cfb6cacf"
    sha256 cellar: :any, ventura:        "a5bf445ba0ee120e54258115f155a4c209fbdfc825239f8ce33c932dc51e0764"
    sha256 cellar: :any, monterey:       "a0152ba9f6a7d6886e262920998baaf7d150288a1da632410896af708337c62f"
    sha256               x86_64_linux:   "c364201ab0b742ab021eeff51c753f88b303e38a6266ca6398193f06c171c059"
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
