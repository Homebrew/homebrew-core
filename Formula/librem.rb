class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "https://github.com/baresip/rem"
  url "https://github.com/baresip/rem/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "16885d9343bab4186a2804107016076d06794d71a46cd70daba05b8fa897e024"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d0cf64aa790ea6aac79182d29099c1cc42cb1752297bda95a28fc4025584b836"
    sha256 cellar: :any,                 arm64_monterey: "087ec2256e2018f922c5d3079924aabe4aca4b3ade6f8962b33830804f4c6a8b"
    sha256 cellar: :any,                 arm64_big_sur:  "be1d9c635cd194bd454469bc881559b46ac880a547996fe8d647a4d6383ceb5c"
    sha256 cellar: :any,                 ventura:        "e3b0095dbcde57dd96bc76491cad7afb1496bcb511a967bbf42f31c837ec404e"
    sha256 cellar: :any,                 monterey:       "d4781737400aa7d6d175a92e720f08a05ff1b2d05a3e6611eb92c1579f77fe15"
    sha256 cellar: :any,                 big_sur:        "dca401b156819e3cceccb9abc2aab5e49ff1d21fa52380de3562ee5a5d8f9ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51a69e77ce208071f5887d222ba6808bc4aab080c0866879c3bc533c0b6e2e1f"
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
