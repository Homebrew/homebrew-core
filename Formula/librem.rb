class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "https://github.com/baresip/rem"
  url "https://github.com/baresip/rem/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "16885d9343bab4186a2804107016076d06794d71a46cd70daba05b8fa897e024"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3ea8f59100eb3baf3f018972e3a634ad814d455cfa695c82dbeec2ddba7dfaaa"
    sha256 cellar: :any,                 arm64_monterey: "a9a01a893f1e63dcbe01354ecd48ff2543176de0345d3b887abb1cd557196175"
    sha256 cellar: :any,                 arm64_big_sur:  "a99a70e37f0f657290b4373fb3311d35d44598a11d29573e8aee286457e87cd5"
    sha256 cellar: :any,                 ventura:        "7b745dc6f93857733d9aa007e179135f2fd0beea31a6b429de8bd921202ba6a7"
    sha256 cellar: :any,                 monterey:       "fb490ad1f4a51300c6b2d0fbb294ffb7c6cc3b65dcf1e3c4045cc8e116a9c605"
    sha256 cellar: :any,                 big_sur:        "047852cd1d0574e5f8e5cd30a65eb334be7156968270a8c9efa453bf2d74249d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb0275896a553b748e3600fb3c86073277724b215a41176162ca4dba93867885"
  end

  depends_on "cmake" => :build
  depends_on "libre"

  def install
    libre = Formula["libre"]
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DRE_INCLUDE_DIR=#{libre.opt_include}/re
    ]
    system "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      #include <rem/rem.h>
      int main() {
        return (NULL != vidfmt_name(VID_FMT_YUV420P)) ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-lrem", "-o", "test"
    system "./test"
  end
end
