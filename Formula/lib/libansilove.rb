class Libansilove < Formula
  desc "Library for converting ANSI, ASCII, and other formats to PNG"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/libansilove/releases/download/1.4.6/libansilove-1.4.6.tar.gz"
  sha256 "0d445622356d4aa9766c32c8696ff073e3d2449fae85c57fc3f0862cb59fab3a"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dab456cf1b3505bd59869c907199f9c98e5d1097142321c35569cbcaf67122d5"
    sha256 cellar: :any, arm64_tahoe:       "1d32ed0dd03e77883a4ae323c45e21c1a75551d5bae0d6f84f320263a866a77a"
    sha256 cellar: :any, arm64_sequoia:     "6a58d659fef62b378338a971410e7753de4297131e35892b4e606e875c80c056"
    sha256 cellar: :any, arm64_linux:       "4f0e2fdf8101256df0bcaae3c3aa89a86b559da6d57db8cd6baef5d434cc69a0"
    sha256 cellar: :any, x86_64_linux:      "8d2989ccf5f4e7b120a03a714709f66dd90ec45acd6f47197ebf7d632af0d5b8"
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
