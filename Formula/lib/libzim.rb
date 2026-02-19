class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.5.0.tar.gz"
  sha256 "0e5290a21a4efe8281dfa2325c59d465ba8ace7ccc1082554763c1a58fdd3b42"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "48cd61ca906e796a5f052b7b785a246990586710911f35a8e8aa972b5ffd3577"
    sha256 cellar: :any, arm64_sequoia: "d1e87bf314c5ab7de2d12ce2ff2073e9d1f024cd49bcb034f1210b53a115b83c"
    sha256 cellar: :any, arm64_sonoma:  "575d6fa8bdd1101954af9bac8deaeb67d0d2dd8d8ca3048eeef6b954438189e1"
    sha256 cellar: :any, sonoma:        "15469b111c56d8875e9c52032b604b7c388ab6d020af76c8c9b42ce4bc4da64b"
    sha256               arm64_linux:   "5656b7a4989035f58dad78310331da9e5daa4118f2350dce1af647d236659689"
    sha256               x86_64_linux:  "823f50ac913f732fb96348bcd043fb5047b95b823cf02c5e3f7109c08be438c2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "icu4c@78"
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
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <zim/version.h>
      int main(void) {
        zim::printVersions(); // first line should print "libzim <version>"
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzim", "-o", "test", "-std=c++11"
    assert_match "libzim #{version}", shell_output("./test")
  end
end
