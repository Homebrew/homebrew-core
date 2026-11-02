class Libansilove < Formula
  desc "Library for converting ANSI, ASCII, and other formats to PNG"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/libansilove/releases/download/1.4.4/libansilove-1.4.4.tar.gz"
  sha256 "c07a20bd3bf4d495cc831206ec8fd4a64fdd899241893a771df6776e4109f912"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9b9449b1a729e50657e69546553982c902d6076ac3283d7fe2d70b965335d861"
    sha256 cellar: :any, arm64_tahoe:       "05750bb6ea0c917cedbdcab46763a7a60818535cde27094b678a088c23a6418f"
    sha256 cellar: :any, arm64_sequoia:     "e11c21748d728daa3a0ddc91b57842a68cbb9c8d33ae365b7cd927c2ca2b939c"
    sha256 cellar: :any, arm64_linux:       "9cab48c78b266bcb6dc3fc3f398b3cfb01145f52dac29e2592c789476d9ed81a"
    sha256 cellar: :any, x86_64_linux:      "8c0b263912540b7771d181ecad101f61a48cfe914ef1b3d366f00619a6075dfe"
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
