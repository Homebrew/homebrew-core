class Libyang < Formula
  desc "YANG data modeling language library"
  homepage "https://github.com/CESNET/libyang"
  url "https://github.com/CESNET/libyang/archive/refs/tags/v5.8.6.tar.gz"
  sha256 "6906b0f26c1d4494c5c2464313b16169ec92ccd07b45ecf3a1e9eb9cd7a55c0b"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "df2603408387362fe94e1ac5edeafbac46321f9f9f755cab342c7c342db58249"
    sha256 arm64_sequoia: "0492d0014e209506ee5226ba0845ecec581310a60077e91f2427c2f727a7e9f3"
    sha256 arm64_sonoma:  "a9faede86d3f06e93214b1b34ae4b0f9babcad694ee135876999334b8a1ad9de"
    sha256 sonoma:        "715fd9ad19079c748720f743be056834261b817e1a261b4cad3e1747b749772e"
    sha256 arm64_linux:   "c44b9fd6eb56a1fcbdaeccadef17c4446be642b96c1da0c1b53f53ef5d395ea2"
    sha256 x86_64_linux:  "29a4c2815e999c23334bf39ef9a46cb15994ce563ef164dfa9c1138173df48a3"
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{lib}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # A small standalone module exercises basic schema parsing and tree output.
    (testpath/"homebrew-libyang-test.yang").write <<~YANG
      module homebrew-libyang-test {
        namespace "urn:homebrew:libyang:test";
        prefix hblt;

        container settings {
          leaf hostname {
            type string;
          }

          list interface {
            key "name";

            leaf name {
              type string;
            }

            leaf enabled {
              type boolean;
            }
          }
        }
      }
    YANG

    expected_tree = <<~TREE
      module: homebrew-libyang-test
        +--rw settings
           +--rw hostname?   string
           +--rw interface* [name]
              +--rw name       string
              +--rw enabled?   boolean
    TREE

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <libyang/libyang.h>
      #include <libyang/parser_schema.h>
      #include <libyang/printer_schema.h>

      int main(int argc, char *argv[]) {
        struct ly_ctx *ctx = NULL;
        struct lys_module *module = NULL;
        char *tree = NULL;
        int ret = 1;

        if (argc != 2) {
          return 1;
        }

        if (ly_ctx_new(ly_yang_module_dir(), 0, &ctx) != LY_SUCCESS) {
          return 1;
        }

        if (lys_parse_path(ctx, argv[1], LYS_IN_YANG, &module) != LY_SUCCESS) {
          goto cleanup;
        }

        if (lys_print_mem(&tree, module, LYS_OUT_TREE, 0) != LY_SUCCESS) {
          goto cleanup;
        }

        fputs(tree, stdout);
        ret = 0;

      cleanup:
        free(tree);
        ly_ctx_destroy(ctx);
        return ret;
      }
    C

    # Compile and run a program that links libyang and renders the module tree.
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lyang", "-o", "test"
    assert_equal expected_tree, shell_output("./test homebrew-libyang-test.yang")

    # Check the installed CLI reports the formula version and renders the same tree.
    assert_match version.to_s, shell_output("#{bin}/yanglint --version")
    assert_equal expected_tree, shell_output("#{bin}/yanglint -f tree homebrew-libyang-test.yang")
  end
end
