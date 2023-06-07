class Perceptualdiff < Formula
  desc "Perceptual image comparison tool"
  homepage "https://pdiff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pdiff/pdiff/perceptualdiff-1.1.1/perceptualdiff-1.1.1-src.tar.gz"
  sha256 "ab349279a63018663930133b04852bde2f6a373cc175184b615944a10c1c7c6a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cd7694959ea2d1c45f69101b17974cad283ad5075ff3adb0b5efed3a23549f47"
    sha256 cellar: :any,                 arm64_monterey: "aada4032f19de165252aa13e584609103b36cb3c62e17ef5519122409cb7a0a4"
    sha256 cellar: :any,                 arm64_big_sur:  "6260c155e96ef17bdaf4ba1032986371db4748e3de145c5354e936fd0f854875"
    sha256 cellar: :any,                 ventura:        "c329dd1cd469f9e1a4efdee715c8aa3722dd35633ebd984f90f1e54638332aee"
    sha256 cellar: :any,                 monterey:       "fd75a857ebc139216c5edc6c671c60ca9d3862a5f7702bfe33fb5293c2ba6a30"
    sha256 cellar: :any,                 big_sur:        "fdc7e444e4d48802ce4a7c671260ec1a51ebb100248d4cb90622ce3cb2dfce82"
    sha256 cellar: :any,                 catalina:       "9edad00fd4470f908e5f9e1eb8c96c364b94c504dab46d1f38a45036871a10a0"
    sha256 cellar: :any,                 mojave:         "1d3d02c27772801105fe9cf3e3ad697bcbeb4db9b260f134bd3e342344455481"
    sha256 cellar: :any,                 high_sierra:    "683d05fc64186ee518180b56345d446be90ff2c42666c80adb86bc185d20d283"
    sha256 cellar: :any,                 sierra:         "eb2da458eda1cebc7872b2621c96e5aa627d9711f8d31fb792cb092d92d060db"
    sha256 cellar: :any,                 el_capitan:     "d47d680df91ee88897f95123e6b9f972351a603a5f4921726b2877cc2e67924f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17bf61ff6c7342680902d574cc000bedecbcc409f292891754b804aacab9216a"
  end

  depends_on "cmake" => :build
  depends_on "freeimage"

  def install
    # cstdio header should be included explicitly to placate older compilers
    # Included upstream in https://sourceforge.net/p/pdiff/code/53/, remove on next release
    inreplace "Metric.cpp", "#include \"Metric.h\"\n",
              "#include <cstdio>\n#include \"Metric.h\"\n"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    test_tiff = test_fixtures("test.tiff")
    test_png = test_fixtures("test.png")

    # Comparing an image against itself should give no diff
    identical = shell_output("#{bin}/perceptualdiff #{test_tiff} #{test_tiff} 2>&1")
    assert_empty identical

    different = shell_output("#{bin}/perceptualdiff #{test_png} #{test_tiff} 2>&1", 1)
    assert_equal "FAIL: Image dimensions do not match", different.strip
  end
end
