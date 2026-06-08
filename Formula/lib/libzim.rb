class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.7.0.tar.gz"
  sha256 "2c40143fd3a365e08f6861587789b9976f66992f5e941d82b6db8f3bb41e085e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a8ba9b1a3def50c6082b91f9990d8c8fa70e0225659bc8f177aa5745524d3dfb"
    sha256 cellar: :any, arm64_sequoia: "04e5f1f940a6b1f2f750e5f86e4d2f81d2fe66811fcdb4bb60ece14bb9457266"
    sha256 cellar: :any, arm64_sonoma:  "66e1d5260e5837dfedd05b87ee8b112036c65bab5cd69cbaf3cc3910a27ef6f4"
    sha256 cellar: :any, sonoma:        "208123f4a5647b4cdd63c18e393f513d7dc2a2ad7c433612c8a792bbb79e6b80"
    sha256               arm64_linux:   "d364a80e13808233938a97b57cabe483c0452d38f4e661b07270ef5e420c135d"
    sha256               x86_64_linux:  "a8b9ee6d6c021ceaf7450a715d113f09de0a837b0dc6b0ec8b752e1b94e41cc7"
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
