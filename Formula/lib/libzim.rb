class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.4.0.tar.gz"
  sha256 "000d6e413963754c0e28327fbdd0a04afd05ea2a728f6438ef96795a2aa3edb8"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "376eb586b5026068b2b37392d3be0c6090c577c3b34d12ca7221294c17c86b5a"
    sha256 cellar: :any, arm64_sequoia: "797a2055096965894962df3041535b78aa311f258828f948f4914f3d2733f832"
    sha256 cellar: :any, arm64_sonoma:  "d1127272d26007ab1900fa55c1093b4102a82550dc2a05b06e00aff859695f0d"
    sha256 cellar: :any, sonoma:        "ff6ebec3272da97bdcc27a3403aeae19104d952f0fac49d81a817efa1f4185d8"
    sha256               arm64_linux:   "1901e1fb8c2a7e520ac4457a9702fbf7cc58e532b05145f4fd05aaf085f9c5de"
    sha256               x86_64_linux:  "3344cdd31e0e583d618f63c5949e485d7f2a8afdce41ada10d3b75ab52d80d49"
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
