class Cahute < Formula
  desc "Library and set of utilities to interact with Casio calculators"
  homepage "https://cahute.org/"
  license "CECILL-2.1"
  head "https://gitlab.com/cahute/cahute.git", branch: "develop"

  stable do
    url "https://ftp.cahute.org/releases/cahute-0.6.tar.gz"
    sha256 "2fb0a8f0b14d75fb0d8a6fa07f3feda9b4cfaad11115340285e2c9414565059c"

    # Backport https://gitlab.com/cahute/cahute/-/commit/10c389c8917438ae64335f34613bd4e45f6e8a30
    patch :DATA
  end

  livecheck do
    url "https://ftp.cahute.org/releases/"
    regex(/href=.*?cahute[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "e2f39454133cb654614ede24a0f040a11105d7e78244b470faee5d2a2fe063e8"
    sha256 cellar: :any,                 arm64_golden_gate: "85bf7f1dcb1219b486d0f66b17b5d31e2aebcba1b4d02bc7ddfcf6487ad4e743"
    sha256 cellar: :any,                 arm64_tahoe:       "cb42203525d8516537043a35201cf297d36c0ad965da1ea890b13f75c25bb2b3"
    sha256 cellar: :any,                 arm64_sequoia:     "a9f182ecca26940644fc57a55482d3cea23db23a9b7bc04d631d79ceaa4009c8"
    sha256 cellar: :any,                 arm64_sonoma:      "5538bcc49d7187f12c367f25303f72880ef2ec69aca596dc4c6d50cd315fefa2"
    sha256 cellar: :any,                 arm64_ventura:     "7fcf7b11c26bf1cee45ea46082d741952de45c82f3532f2849468495351ee161"
    sha256 cellar: :any,                 sonoma:            "56ce31df801211ccaf95a98f2d2dd9b8c79870d6aaa5784c039bd4a2b85936a7"
    sha256 cellar: :any,                 ventura:           "1aa7caddf5a84461d3633f09d878704f395ab7e0467f0817be79cd23ceaa10de"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "82332e01cda2c06e1d9cc09981c57ab9c00edbf1eb62219ee4b0838ecb821c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a58adf247829574b1deab7b035c71ec60e404e889241dc8e5910458508e09dec"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.15" => :build
  depends_on "libusb"
  depends_on "sdl2-compat"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DPython3_EXECUTABLE=#{python3}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Assume that there is no calculator connected while testing
    assert_match "Could not connect to the calculator.", shell_output("#{bin}/p7 idle 2>&1", 1)
    assert_match "Could not connect to the calculator.", shell_output("#{bin}/p7screen 2>&1", 1)
    assert_match "Could not connect to the calculator.", shell_output("#{bin}/xfer9860 -i 2>&1", 1)

    # No calculator is connected, so this will also fail. Any test file will do.
    shell_output("#{bin}/p7os flash #{test_fixtures "test.ico"} 2>&1", 1)

    # Taken from https://cahuteproject.org/developer-guides/detection/usb.html
    (testpath/"usb-detect.c").write <<~C
      #include <stdio.h>
      #include <cahute.h>

      int my_callback(void *cookie, cahute_usb_detection_entry const *entry) {
          char const *type_name;

          switch (entry->cahute_usb_detection_entry_type) {
          case CAHUTE_USB_DETECTION_ENTRY_TYPE_SERIAL:
              type_name =
                  "Serial calculator (fx-9860G, Classpad 300 / 330 (+) or "
                  "compatible)";
              break;

          case CAHUTE_USB_DETECTION_ENTRY_TYPE_SCSI:
              type_name = "UMS calculator (fx-CG, fx-CP400+, fx-GIII)";
              break;

          default:
              type_name = "(unknown)";
          }

          printf("New entry data:\\n");
          printf(
              "- Address: %03d:%03d\\n",
              entry->cahute_usb_detection_entry_bus,
              entry->cahute_usb_detection_entry_address
          );
          printf("- Type: %s\\n", type_name);

          return 0;
      }

      int main(void) {
          cahute_context *context;
          int err;

          err = cahute_create_context(&context);
          if (err) {
              fprintf(
                  stderr,
                  "cahute_create_context() has returned error %s.\\n",
                  cahute_get_error_name(err)
              );
              return 1;
          }

          err = cahute_detect_usb(context, &my_callback, NULL);
          if (err)
              fprintf(stderr, "Cahute has returned error 0x%04X.\\n", err);

          cahute_destroy_context(context);
          return 0;
      }
    C

    pkg_config_cflags = shell_output("pkg-config --cflags --libs cahute libusb-1.0").strip.split
    system ENV.cc, "usb-detect.c", *pkg_config_cflags, "-o", "usb-detect"
    system "./usb-detect"
  end
end

__END__
diff --git a/chars/process_chars.py b/chars/process_chars.py
index a3c33ac7cdaea316db6ec2b475498e978196c8af..5e06cd4f7b5ab25c6a9dd278912819dbea8c8af4 100644
--- a/chars/process_chars.py
+++ b/chars/process_chars.py
@@ -26,10 +26,7 @@
 # The fact that you are presently reading this means that you have had
 # knowledge of the CeCILL 2.1 license and that you accept its terms.
 # *****************************************************************************
-"""Process the character references.
-
-This script requires the ``toml`` package to be installed.
-"""
+"""Process the character references."""
 
 from __future__ import annotations
 
@@ -38,9 +35,9 @@ from dataclasses import dataclass, field
 from logging import getLogger
 from os import makedirs
 from pathlib import Path
+import tomllib
 from typing import Any, Iterator, Literal
 
-import toml
 
 CharacterTableKey = Literal["legacy", "9860"]
 """Type representing a character table."""
@@ -298,7 +295,8 @@ class CharacterReference:
         }
 
         try:
-            raw_data = toml.load(path)
+            with open(path, "rb") as f:
+                raw_data = tomllib.load(f)
         except ValueError:
             logger.exception("Could not load the TOML file")
             raise
