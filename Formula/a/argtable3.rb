class Argtable3 < Formula
  desc "ANSI C library for parsing GNU-style command-line options"
  homepage "https://www.argtable.org"
  url "https://github.com/argtable/argtable3/releases/download/v3.3.1/argtable-v3.3.1.tar.gz"
  sha256 "c08bca4b88ddb9234726b75455b3b1670d7c864d8daf198eaa7a3b4d41addf2c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/argtable/argtable3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "81744f4898904ac8875efc23088a93fe96a5a2a006e38c8c0d85c4829191a79e"
    sha256 cellar: :any,                 arm64_sequoia: "10573b21ace23e3660cf5377e121b52359f70553e819ea2a0b0557550d01552d"
    sha256 cellar: :any,                 arm64_sonoma:  "ac1030006031bf18e5203703e907eacade6f3dfca5090185ef3c7d09cb88c92d"
    sha256 cellar: :any,                 sonoma:        "cf6d9f2e1097682bed94e5d18749fd68707f108c3faf8536fbcbfdd5a6479331"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cb5824b74df9c9d01460afcb252e9812d4365e4e5135e10248d24e9dba3546d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec7221f8528359814a9f3a6eb20b7d8b53677edb6f97fddd6ca64371b9c1dda8"
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
