class Libansilove < Formula
  desc "Library for converting ANSI, ASCII, and other formats to PNG"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/libansilove/releases/download/1.3.1/libansilove-1.3.1.tar.gz"
  sha256 "4919d9a1243df7b23de677ea595f56aa7f6be7187fb0835f1915a06865c11f85"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a119370b770618edb36cba9dd12c3ca461c5203ede0a3e9b35e260aeea2a1c04"
    sha256 cellar: :any,                 arm64_monterey: "72a6824d93c50b1745a9a9b0540f7e6037136322017bfdae7a691fa82a432508"
    sha256 cellar: :any,                 arm64_big_sur:  "7e16775fc888b219e6a1aa91cbc364f95bd4b29be6969301b72b8cd4d9ecddba"
    sha256 cellar: :any,                 ventura:        "58302db2bcfef0eb28c35a05b565a954936b8fb864fcfd5556118d4001992680"
    sha256 cellar: :any,                 monterey:       "8a51214b8cab8d5f07831ece9877f436b3f6982fb23a8cf2158e406dbc4525e0"
    sha256 cellar: :any,                 big_sur:        "85b2bbf28557b4105ba352129e50bec2013bfff45e7e69c44490b52d4ec5ddd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba47e2c915af469866f1d726e03cad019a33872d147c344c06523d1a223b1c1d"
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
