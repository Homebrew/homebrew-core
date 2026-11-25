class Libansilove < Formula
  desc "Library for converting ANSI, ASCII, and other formats to PNG"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/libansilove/releases/download/1.4.7/libansilove-1.4.7.tar.gz"
  sha256 "fa157859d394e0cddbd6199faa0bf477786c6ccbff1d4cb4d112ad0c23ff54d2"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    manifest_sha256 "8ad938484ae8c37dcc7d67b44c0912ac5f59d1884ee7f882ffa199b50f96bfbe"
    sha256 cellar: :any, arm64_golden_gate: "5b0fa8b80a099abb0c7e1fa680dd919e71ba6b75da045ab382f467ab2d90692c"
    sha256 cellar: :any, arm64_tahoe:       "be696d858088181525addf4f616271f40194ef24a092997bf354a752370e26bb"
    sha256 cellar: :any, arm64_sequoia:     "33a951f8739a1956bea8f154617322176db2d07d98a2f66c0bcc6641fa4c6d3c"
    sha256 cellar: :any, arm64_linux:       "a119d2387e10a9a156d94cc08b7d5244d2318db45eb2f785d264e96199495988"
    sha256 cellar: :any, x86_64_linux:      "c0b0f8aac4af2010b03a792956d3f7b50291f6f69e1dc5d7c682878dc8aa2b25"
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
