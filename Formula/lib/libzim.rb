class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.4.1.tar.gz"
  sha256 "0937b21cd7d0c600e907871784181a2d152a6f8a619ff092d760c26f796e4315"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "66ccd451705a1d09bc72e6b3742964321c4a537a152f4bd1e0cd5eadeba1b88e"
    sha256 cellar: :any, arm64_sequoia: "50f4e42c00c89d50a5d1b97357a12f01b5200cdfce1d6be62f549e860c118e1b"
    sha256 cellar: :any, arm64_sonoma:  "7722a4cbbb6dfdfafd8d2ed0d6055ee6da523eeca35112a85c5bd1127ea5b8f7"
    sha256 cellar: :any, sonoma:        "e7e9094e7689fbfb969e71d51533b7b656cb5b24e3bbbc1c97bc10af2e2746ae"
    sha256               arm64_linux:   "0db1b0db7a51dee1eb13bb82b76702d0ea5cb2035dd3c3ac53f47c1587b79423"
    sha256               x86_64_linux:  "b7928de5ebf72ba32c08a48c209cd299a87b4b567274ba085b059d2fc5178a29"
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
