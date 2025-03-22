class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.2.3.tar.gz"
  sha256 "7c6e7fcaf5bc82447edb12c6c573779af6d77b3b79227da57586e81c4e13f1bf"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_sequoia: "0f7b5ed88d189f946020179039adfe64ba74df4a6c6fd9e16c7fc37d2353da44"
    sha256 cellar: :any, arm64_sonoma:  "d9c654e92d111e38f9ae04f4eb6735b064873a7b34c8f3df06dd813740a3f46b"
    sha256 cellar: :any, arm64_ventura: "1826eb83d9904bd839fd9459f8bf0effb234e25d3724b14f06ab9d065a284a70"
    sha256 cellar: :any, sonoma:        "5701596ba77fb25c9b4990ac647592844d0a53bbf6213dd4c5afedbf2921eba5"
    sha256 cellar: :any, ventura:       "44801a35ab9a4ad761fe566e565cb2d41d3faf1e2a132b977a46902686570150"
    sha256               arm64_linux:   "455af49f77ee108e0d4a963709985a36666136a037ddde4d5d044d80073e2d9a"
    sha256               x86_64_linux:  "92e210cb78cc081b61445f86c3311afbc469ab8edf2eb2a04c6f3f96ba8dbc5a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "icu4c@77"
  depends_on "xapian"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "python" => :build

  # Apply commit from open PR to fix build with ICU 76+
  # PR ref: https://github.com/openzim/libzim/pull/936
  patch do
    url "https://github.com/openzim/libzim/commit/48c8c3fa7ad7a54f6df9a5be2676d189bbaf0022.patch?full_index=1"
    sha256 "f88890feab66aec7861b4eaab58202d6417c7c4d3692fe56f0e4b5fba06c64a3"
  end

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

    # Assert the first line of output contains "libzim <version>"
    assert_match "libzim #{version}", shell_output("./test")
  end
end
