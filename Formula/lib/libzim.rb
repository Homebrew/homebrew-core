class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.6.0.tar.gz"
  sha256 "a4211000de19df0a36dd48180b295be63adfbdaba3ef75545b32087c0bd8189d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f5fc6189562c702b312da814e7baa8dbedbaf4e9e3aa59f1943aed9c97d43bce"
    sha256 cellar: :any, arm64_sequoia: "3ba68b385ea740d52aca5e0ec429236a67c7dbe5f23a3372e00634eec09c3d9f"
    sha256 cellar: :any, arm64_sonoma:  "75b3129fa488d6418f613c8feb6480ae15d49b89388fb73c8889d0a72460911b"
    sha256 cellar: :any, sonoma:        "99d71a24d7b6a817537df12cbc879750225e5728026b18bb514e6a0d9d9e2e65"
    sha256               arm64_linux:   "2c25bff188af83c9774a609b3ab1e28ec729616de18542cd75977819be555038"
    sha256               x86_64_linux:  "794aba6a2c67ce2ab79181b016c8747ea2731fdb15cf1580038f81df54f7beec"
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
