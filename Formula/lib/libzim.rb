class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.4.0.tar.gz"
  sha256 "000d6e413963754c0e28327fbdd0a04afd05ea2a728f6438ef96795a2aa3edb8"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4dae23a536e3a6dcd0ef4b6dac9c8d0c40ec3cfd1586b173264950c850f41e22"
    sha256 cellar: :any, arm64_sequoia: "377b92d544199a6852126d0733a6947720a940982705823bab0bf444c9acbd30"
    sha256 cellar: :any, arm64_sonoma:  "af1d8cd970417f1168209a4eac899d3081564e5b9d3da92dab4f42b78b911508"
    sha256 cellar: :any, sonoma:        "827c90c7e7c9f65b9800e7f755a4bcbd0a2acba0e4c7549ad85cdbf5e1aed289"
    sha256               arm64_linux:   "6ec3ed32bfa9e5fafd61ff5d62b958789d3d12bde48e7f1baba7f8b8af96ef1f"
    sha256               x86_64_linux:  "b50a2014777b05dc69c1ff13507ca415a55222e7387de5c4aa5ad6ba33ed7c88"
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
