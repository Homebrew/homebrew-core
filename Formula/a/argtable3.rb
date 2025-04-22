class Argtable3 < Formula
  desc "ANSI C library for parsing GNU-style command-line options"
  homepage "https://www.argtable.org"
  url "https://github.com/argtable/argtable3/archive/refs/tags/v3.2.2.f25c624.tar.gz"
  version "3.2.2"
  sha256 "a5c66d819fa0be0435f37ed2fb3f23e371091722ff74219de97b65f6b9914e51"
  license "BSD-3-Clause"
  head "https://github.com/argtable/argtable3.git", branch: "master"

  # Upstream uses a tag format including a version and hash (e.g.
  # `v3.2.2.f25c624`) and we only use the version part in the formula, so this
  # omits the hash part to match.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:\.\h+)?$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "977cc6d2b39d50551e00be1cb664891ba886e3e63779769713815ab5c830d4f7"
    sha256 cellar: :any,                 arm64_sonoma:  "59140a12791b4cd3733fd383bbd91373d517ed6a22dded4ae9e74b8fd2039844"
    sha256 cellar: :any,                 arm64_ventura: "baa86eebd002149a8653eb04d365be6b4526551c7ae43cbf9753642093bad9e7"
    sha256 cellar: :any,                 sonoma:        "ab5266a8ad714236feda7b450da27138538019d765fd7311d613596cd9a82140"
    sha256 cellar: :any,                 ventura:       "b88c3b8acd8fe222ddadd092036daabe726784c2583e2665da98188af700b669"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6651b1d66020b8752956e2d278c447bbbee872f09db99828c81dbd75817c08c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1582d82a062451b9b81bd1739f541876e41b2c821b274aba6a51f9d3009ac7a5"
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
