class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://download.openzim.org/release/libzim/"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.8.0.tar.gz"
  sha256 "27a6dadd56eef37cf025e68f938ab1f193cd6eb3ddadc624c6f75fb06658410c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8a4c338c7b7eeea1ae9029c6aef8c206d92679b6a1a9dd196f9929078767fea3"
    sha256 cellar: :any, arm64_sequoia: "ab5942b30c92e39873a494cbae409935a3f3374e569edf37e6dafd68a6c7bdbc"
    sha256 cellar: :any, arm64_sonoma:  "31567ad7b36a05a7a67a67ddfd8d3863462048e1658996d268db9509624c5890"
    sha256 cellar: :any, sonoma:        "6a3e136b09cfb883dc237f2c8fa4273f9bf554f8ab15c7e165146c8bf3959065"
    sha256               arm64_linux:   "dd85d0009c37308d81117eec3bb4db495ae75eeb125d795052cef5aa678e091b"
    sha256               x86_64_linux:  "c9c539bcdde31c43689f356096ed2b2f62519a9e60a3c0e017d81e8471bf6117"
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
