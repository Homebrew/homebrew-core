class Cahute < Formula
  desc "Library and set of utilities to interact with Casio calculators"
  homepage "https://cahuteproject.org/"
  url "https://ftp.cahuteproject.org/releases/cahute-0.2.tar.gz"
  sha256 "70e7f12747bee8b5be7c29ecbb0c447b7c54708c3cb31fb141396776dbbe9eee"
  license "CECILL-2.1"

  depends_on "cmake" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "libusb"
  depends_on "sdl2"

  patch :DATA

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/p7", "--version"
    system "#{bin}/p7os", "--version"
    system "#{bin}/p7screen", "--version"
    system "#{bin}/xfer9860", "--version"

    # Taken from https://cahuteproject.org/developer-guides/detect-usb.html
    (testpath/"usb-detect.c").write <<~EOS
      #include <stdio.h>
      #include <cahute.h>

      int my_callback(void *cookie, cahute_usb_detection_entry const *entry) {
          char const *type_name;

          switch (entry->cahute_usb_detection_entry_type) {
          case CAHUTE_USB_DETECTION_ENTRY_TYPE_SEVEN:
              type_name = "fx-9860G or compatible";
              break;

          case CAHUTE_USB_DETECTION_ENTRY_TYPE_SCSI:
              type_name = "fx-CG or compatible";
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
          int err;

          err = cahute_detect_usb(&my_callback, NULL);
          if (err)
              fprintf(stderr, "Cahute has returned error 0x%04X.\\n", err);

          return 0;
      }
    EOS
    system ENV.cc,
      *shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs cahute libusb-1.0").strip.split,
      "usb-detect.c",
      "-o", "test"
    system "./test"
  end
end

# This patch is from commit 157f710ccd99ac6eb2595dec136f0b4a93a8bcbb
# at https://gitlab.com/cahuteproject/cahute
# It is needed to install p7os, which was
# accidentally left out of the installation
# lists in CMake. The issue is resolved upstream.
__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 5d655f4..6d503f0 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -125,6 +125,7 @@ target_link_libraries(xfer9860 PRIVATE ${PROJECT_NAME} PkgConfig::libusb)
 
 install(TARGETS ${PROJECT_NAME} ARCHIVE)
 install(TARGETS p7 RUNTIME)
+install(TARGETS p7os RUNTIME)
 install(TARGETS p7screen RUNTIME)
 install(TARGETS xfer9860 RUNTIME)
 install(
-- 
