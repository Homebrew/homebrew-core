class Libyang < Formula
  desc "YANG data modeling language library"
  homepage "https://github.com/CESNET/libyang"
  url "https://github.com/CESNET/libyang/archive/refs/tags/v6.4.13.tar.gz"
  sha256 "bf78a437225027ce9e20d2c449b7853204d7fd450bb00fb01e83339145561a86"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_golden_gate: "cda40e72aaeca6bcfe1fce5de806d3327822c60219ee4e6ab96791ae10ea10a8"
    sha256 arm64_tahoe:       "2b2f9e9250633843249a274168940e6103a785691cef820a4da691ee46a19591"
    sha256 arm64_sequoia:     "0736495a772692d11043f9cbee93372540930db413ef1514fa2c2e0b3ba940e0"
    sha256 arm64_linux:       "5a2d7b9519e87c08a374be74c4b92fe541c079e1f815812f6d17975403e2f823"
    sha256 x86_64_linux:      "32000a77ae1eca071c483bb578cf496d581b3d52259fe8eb6e05c48b9ba49f08"
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  deny_network_access!

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
