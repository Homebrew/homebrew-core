class Libansilove < Formula
  desc "Library for converting ANSI, ASCII, and other formats to PNG"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/libansilove/releases/download/1.4.5/libansilove-1.4.5.tar.gz"
  sha256 "ac9d8233255c34da1b4fe426feb046089fa616d1245fb86341e90873d37407fd"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1fdcc579de05c1fea4f30b1b13444c447b4f05479c60bb60ab8a3ecf7a29e228"
    sha256 cellar: :any, arm64_tahoe:       "9dc28f40a061ddcbd239866f2c2ad3c7c7697f9a4a5bb4d16a3f86303e9815e8"
    sha256 cellar: :any, arm64_sequoia:     "57d657904b98a7b338ba474817ec01ca9d54c5ef3147e3a02f6f80f7283d52d0"
    sha256 cellar: :any, arm64_linux:       "645447daebe7cecf40eca3c750d99809a1199f28948e13e6e0e92b495e90fadd"
    sha256 cellar: :any, x86_64_linux:      "308220070e59779c5cf6dccbad0a96c4dcdddbf8992f3f9b184c0d7961655e9b"
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
