class Libansilove < Formula
  desc "Library for converting ANSI, ASCII, and other formats to PNG"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/libansilove/releases/download/1.4.2/libansilove-1.4.2.tar.gz"
  sha256 "8bd4d0775ff558aacfebd7e7e284baa96d781183bf767283bf8410f44a2e2434"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc81ba49030d1ff262da56b77367d10a98ef1f677415349a0c81c80c052b2750"
    sha256 cellar: :any,                 arm64_sequoia: "dfb18e4ee2a90aede28ee22f8b97de7eb9fa957b0619658788b4e562ba01391e"
    sha256 cellar: :any,                 arm64_sonoma:  "a1cafdd2cb1445925addb324d92288e4f238905416d384571d9769641fc34034"
    sha256 cellar: :any,                 arm64_ventura: "6dec1d8b0d8b0a0ad22327e1d0674bbc557c48999c2f92c6126636f7247475f4"
    sha256 cellar: :any,                 sonoma:        "6e9222974a1c639e44e28db4d3c0e128a95dd0cf4fd7f85254ab649062ead51b"
    sha256 cellar: :any,                 ventura:       "30ee13455efb6991e98ce76c3446a2010bf8ef20bb5c4dda3a6cc04100d865bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "175358f696c2f5286e866f812b7890f15e30555fe5c12bd7eadeb4a8e050db35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "464592e648d31ec4ade3ee710dde95d5059bec8c3fe47bb9881a05cf3b87d449"
  end

  depends_on "cmake" => :build
  depends_on "gd"

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
