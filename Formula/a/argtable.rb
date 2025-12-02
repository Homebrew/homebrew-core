class Argtable < Formula
  desc "ANSI C library for parsing GNU-style command-line options"
  homepage "https://argtable.sourceforge.io"
  url "https://downloads.sourceforge.net/project/argtable/argtable/argtable-2.13/argtable2-13.tar.gz"
  version "2.13"
  sha256 "8f77e8a7ced5301af6e22f47302fdbc3b1ff41f2b83c43c77ae5ca041771ddbf"
  license "LGPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "0f6b3a1af259640264644f92286a3d96e4fb4ca0dd4f16aabbdcf608117bf116"
    sha256 cellar: :any,                 arm64_sequoia:  "ac1c99cc90796da54dcfa48415939944d6608a1284d6c1eb2650d43717a4d622"
    sha256 cellar: :any,                 arm64_sonoma:   "0f2a92f017739cf52ff30229bbbb87fed5e9d818ae9655685227d5f72a94825a"
    sha256 cellar: :any,                 arm64_ventura:  "01d3903a4cc0bd3c007b2c8401479c8abcca6d2f0ace9ad7659e95ee241819db"
    sha256 cellar: :any,                 arm64_monterey: "988e6dea2d2b5b0d6fdd8d6d0b91430ce5e5e61e176550000068983614f4874e"
    sha256 cellar: :any,                 arm64_big_sur:  "ef0f7424fe4d4ec76d19cfaa8a7d4ceda2abcdd13942939f2f708c57b878de1f"
    sha256 cellar: :any,                 sonoma:         "bcfe5a8e2205a9e4de40b83f70306f1a3c9a9e2d896018e1e3b4a16a6560a43f"
    sha256 cellar: :any,                 ventura:        "318ad62fc7490140b41a386483f9d2d45ba040771ebc8a9378ac3f4bf7ca05a2"
    sha256 cellar: :any,                 monterey:       "b1ea013fae36e65f4dcdf7e4d13a2d39332ea02dfbc70d7ca5d707434c47254c"
    sha256 cellar: :any,                 big_sur:        "b5bd39e72d347c2b73845caefb3c44cb9988f3b35ea4fe4b43e765e292b28de4"
    sha256 cellar: :any,                 catalina:       "29bfa5bfd7e897512347ecf664c3e3a9bbe7ec585115c09167ca8b6c312be9d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cb7cc898c5016f533115709f43cb216842c242caf7aa2e4b8e5a178cc9c9572b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "784464fba494301f0f28dfe309112e99267a2a9084243916283ba7c6e2db0a48"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "argtable2.h"
      #include <assert.h>
      #include <stdio.h>

      int main (int argc, char **argv) {
        struct arg_lit *all = arg_lit0 ("a", "all", "show all");
        struct arg_end *end = arg_end(20);
        void *argtable[] = {all, end};

        assert (arg_nullcheck(argtable) == 0);
        if (arg_parse(argc, argv, argtable) == 0) {
          if (all->count) puts ("Received option");
        } else {
          puts ("Invalid option");
        }
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-largtable2",
                   "-o", "test"
    assert_match "Received option", shell_output("./test -a")
    assert_match "Received option", shell_output("./test --all")
    assert_match "Invalid option", shell_output("./test -t")
  end
end
