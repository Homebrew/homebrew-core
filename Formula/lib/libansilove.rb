class Libansilove < Formula
  desc "Library for converting ANSI, ASCII, and other formats to PNG"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/libansilove/releases/download/1.4.1/libansilove-1.4.1.tar.gz"
  sha256 "c6aa32bcef54b05b9af535c621f7044156295a49cea3cfaf1c868e359be59203"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1f88f4ffc2cd6cba059e88724bd87aacb47d223297a38b78193f8fa69fbb4892"
    sha256 cellar: :any,                 arm64_sonoma:   "e4b2d4873758a43c8b45a86fa3373a2b3f2353814a9e338e604d74d0204f288d"
    sha256 cellar: :any,                 arm64_ventura:  "6faf95a578791fa28160614d77e0b4460e61d80cdf4c55069955e3889f15f658"
    sha256 cellar: :any,                 arm64_monterey: "c97602ff04201633015f09d08e401c4c95a7b42579471826107733ec2f718764"
    sha256 cellar: :any,                 arm64_big_sur:  "ad9a0d7124bf2e66ed5618752d1aa06c079d39f2b686da766c0cf50ec5b55680"
    sha256 cellar: :any,                 sonoma:         "155fb68b8ee7f5fec481d26ddc3b04b67525bec7359847da7a3dda00712f61e6"
    sha256 cellar: :any,                 ventura:        "5e6272f3834cabff4fc7bc6e852ac5577cbe7ee7902fb17b86fde334edb51d47"
    sha256 cellar: :any,                 monterey:       "413f7125c3d514de63cf889a761ef8f572e0c2eea2992aaf8fcd9d40bf3dc816"
    sha256 cellar: :any,                 big_sur:        "c48c991d4e2f7c3962a81305c96d68651d315815acb50d2f714e7bde6dc24942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c04a7521aa0bb995f39e69fa720149b8307e176ab5580b6df6c7a45ce5f35ef"
  end

  depends_on "cmake" => :build
  depends_on "gd"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ansilove.h>

      int main(int argc, char *argv[])
      {
        struct ansilove_ctx ctx;
        struct ansilove_options options;

        ansilove_init(&ctx, &options);
        ansilove_loadfile(&ctx, "example.c");
        ansilove_ansi(&ctx, &options);
        ansilove_savefile(&ctx, "example.png");
        ansilove_clean(&ctx);
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lansilove", "-o", "test"
    system "./test"
  end
end
