class Libansilove < Formula
  desc "Library for converting ANSI, ASCII, and other formats to PNG"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/libansilove/releases/download/1.4.4/libansilove-1.4.4.tar.gz"
  sha256 "c07a20bd3bf4d495cc831206ec8fd4a64fdd899241893a771df6776e4109f912"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b6e0e5bb88c36b447468db240f48efc8780e49f7ed42f97630af89bc39ccdabf"
    sha256 cellar: :any, arm64_tahoe:       "fbe5ab7bef599afc237311c07cb90eccfdec21f0a3799caa6b2ca8a1351a6da7"
    sha256 cellar: :any, arm64_sequoia:     "be99543375629829a7ccb6dbb1e6c902f23af9f7db75fbe2d5e32d70a119ffd1"
    sha256 cellar: :any, arm64_linux:       "395052f55a78697be46463fb028a3b8ac0e5560fa8871e33c1657ae15c24eb12"
    sha256 cellar: :any, x86_64_linux:      "0b3ac1241efa6c7b9af1d0f781fee223146946ed719d1783bb71bcfd83a771be"
  end

  depends_on "cmake" => :build
  depends_on "gd"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lansilove", "-o", "test"
    system "./test"
  end
end
