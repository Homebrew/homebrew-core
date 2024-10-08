class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.2.3.tar.gz"
  sha256 "7c6e7fcaf5bc82447edb12c6c573779af6d77b3b79227da57586e81c4e13f1bf"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sequoia: "d339d5a5890ded1fb8757e081dd2e4d528e3e67e40076b10a0dd15cc82d56723"
    sha256 cellar: :any, arm64_sonoma:  "aae5883407ff954530cb2821d78c0915d7136114cc4248fde3273c391eefc6c0"
    sha256 cellar: :any, arm64_ventura: "590039265eea1d2575e5762ca1dcf3da86fa5227030452ea7153e567e6a50bd6"
    sha256 cellar: :any, sonoma:        "f93174721a118c10a1a457910848da7bd9362276c5e7783ee5c8c6d0b3eaa2df"
    sha256 cellar: :any, ventura:       "ce832e8ec4c125cb7a1a16b6ba016f36a4d2b2759df2c50a05ae74b0a5b5604f"
    sha256               x86_64_linux:  "60f68c10567a9b1f4268af4ac89b9a910e4e69f9c864ec7d96a4e154a86521a7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "icu4c@75"
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
