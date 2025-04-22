class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.3.0.tar.gz"
  sha256 "791220e51e6a160d349491b9744ec1a9c1a104f11a79e8e73673daf242be69ed"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_sequoia: "b4ceecbeedcfc12b93d6f09afd9108509970317095e61792c171908037dfebd7"
    sha256 cellar: :any, arm64_sonoma:  "faebeb4b051a2de69ce34863390dbb6c623ea2f01d0ddc7265e9b73cab5aa917"
    sha256 cellar: :any, arm64_ventura: "0a36f78d2ec284ba491c030e071a9a5875106dac327bd6e060f479410b6c9331"
    sha256 cellar: :any, sonoma:        "c68a4e4aeb4d87ac9faec8349222751f49a4e570c15d5b1c05e93d2ca5cc57a7"
    sha256 cellar: :any, ventura:       "d342df82217c3d5d6e160bd5b5c6eb1301854bfeb7d2691bb250c04e3a634389"
    sha256               arm64_linux:   "5c4f15314c93fa0ab0f858bae329925eb9fabc5eeb75b390b34100f91208d6ee"
    sha256               x86_64_linux:  "8e90267f0cbdcda4336951766f6bce92b4b694031c98b19597ee146546bf9781"
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
