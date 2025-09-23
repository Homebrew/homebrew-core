class Argtable3 < Formula
  desc "ANSI C library for parsing GNU-style command-line options"
  homepage "https://www.argtable.org"
  url "https://github.com/argtable/argtable3/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "8b28a4fb2cd621d8d16f34e30e1956aa488077f6a6b902e7fc9f07883e1519c1"
  license "BSD-3-Clause"
  head "https://github.com/argtable/argtable3.git", branch: "master"

  # Upstream uses a tag format including a version and hash (e.g.
  # `v3.2.2.f25c624`) and we only use the version part in the formula, so this
  # omits the hash part to match.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:\.\h+)?$/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02841c4514ec0b016351a3f513bcb7b529f78e0fbe3e4dbab89b9734d084244e"
    sha256 cellar: :any,                 arm64_sequoia: "08c1d4c1b1caf0027f5965d8f4a33a8634de5d1d2db97215c4cae4dd35a21d83"
    sha256 cellar: :any,                 arm64_sonoma:  "d12329601f98832b51f7d0887754b353116fc91389d7427526f2c7f2d493de64"
    sha256 cellar: :any,                 arm64_ventura: "f49951ca0b688eadaac7d390a5f4cba099dd801c8e1fa772eae1bbd223ee955a"
    sha256 cellar: :any,                 sonoma:        "81aa7acce60ed7c0fbb3f7becf7b93065640a23accbace7b0b98758cc4b034b0"
    sha256 cellar: :any,                 ventura:       "e54312fdc0437c0fac0f877c1f644cea428c82174025607e23e31133a594a51d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a6bd561754762b0b1c295c6d99882e4c98a11783675260c8a99dd3135789b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "569f0abb77d2e4b88ab0e948309bbb78858387ecc9ed8544942020a4bc868ad4"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "argtable3.h"
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

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-largtable3",
                   "-o", "test"
    assert_match "Received option", shell_output("./test -a")
    assert_match "Received option", shell_output("./test --all")
    assert_match "Invalid option", shell_output("./test -t")
  end
end
