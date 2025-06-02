class Argtable3 < Formula
  desc "ANSI C library for parsing GNU-style command-line options"
  homepage "https://www.argtable.org"
  url "https://github.com/argtable/argtable3/archive/refs/tags/v3.3.0.116da6c.tar.gz"
  version "3.3.0"
  sha256 "7c24a61d4ba780ce150adb33f9e815f8b45d65a1a709e63a9bc94ae201490cd2"
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
    sha256 cellar: :any,                 arm64_sequoia: "635c0ac6efb8e89912496bf8d4ed32d0049e0dbc67208c68ac8f17c28b81c9c5"
    sha256 cellar: :any,                 arm64_sonoma:  "11b35a8824c4f7f0c75e219094fa9f0602a40e059a6973bac65c552e5e923977"
    sha256 cellar: :any,                 arm64_ventura: "58361e9bcd9d10fdf9a4c95940fa5860d66bbb0de290f734bc976acd35746b4f"
    sha256 cellar: :any,                 sonoma:        "fb07c6448932f97c7d88283b28050418382f171f60fe63789149010701ae66fd"
    sha256 cellar: :any,                 ventura:       "c8301070f847c59bf5f287b05ab431bca82420366f6e83c515898ab528124bec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05c8078e587693d75a00317b81e8e52ab72a89440749b0c165789636306a928b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83498df70602200dfa267fbc1e15a9b84b22d8439269750366a4247174e316fc"
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
