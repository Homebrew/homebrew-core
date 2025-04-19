class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.3.0.tar.gz"
  sha256 "791220e51e6a160d349491b9744ec1a9c1a104f11a79e8e73673daf242be69ed"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_sequoia: "d7244fd1793443e1462d548dc161ed6a0beca8bbccb8c05665aff15fe9b50ec6"
    sha256 cellar: :any, arm64_sonoma:  "f6dde241d6caba19b5cd6d2df792e0f11d032e811882a08115ad068898e9961e"
    sha256 cellar: :any, arm64_ventura: "cc48b83c33f30e69d663c6b55e37a6656e40216fe9ec4d5f858c968acca243be"
    sha256 cellar: :any, sonoma:        "c29fe24d245623e4d88246b3478732e10426621cc158df3c8649ff11011567c5"
    sha256 cellar: :any, ventura:       "372ed0c4251b62919bc0ca4f1d554552c07eb51475ee7d472141a3a66870bd94"
    sha256               arm64_linux:   "522e8fa8a99207afd443f611ec31b9ad87ef055ef8b2d5069a7bcaa120a031c2"
    sha256               x86_64_linux:  "eab3ced9bdbd896c6894e273a1e3b4bbbb01d65997f8d1866baa40b97e09469d"
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
