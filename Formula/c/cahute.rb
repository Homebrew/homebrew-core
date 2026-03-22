class Cahute < Formula
  include Language::Python::Virtualenv

  desc "Library and set of utilities to interact with Casio calculators"
  homepage "https://cahuteproject.org/"
  url "https://ftp.cahuteproject.org/releases/cahute-0.6.tar.gz"
  sha256 "2fb0a8f0b14d75fb0d8a6fa07f3feda9b4cfaad11115340285e2c9414565059c"
  license "CECILL-2.1"
  head "https://gitlab.com/cahute/cahute.git", branch: "develop"

  livecheck do
    url "https://ftp.cahuteproject.org/releases/"
    regex(/href=.*?cahute[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cb42203525d8516537043a35201cf297d36c0ad965da1ea890b13f75c25bb2b3"
    sha256 cellar: :any,                 arm64_sequoia: "a9f182ecca26940644fc57a55482d3cea23db23a9b7bc04d631d79ceaa4009c8"
    sha256 cellar: :any,                 arm64_sonoma:  "5538bcc49d7187f12c367f25303f72880ef2ec69aca596dc4c6d50cd315fefa2"
    sha256 cellar: :any,                 arm64_ventura: "7fcf7b11c26bf1cee45ea46082d741952de45c82f3532f2849468495351ee161"
    sha256 cellar: :any,                 sonoma:        "56ce31df801211ccaf95a98f2d2dd9b8c79870d6aaa5784c039bd4a2b85936a7"
    sha256 cellar: :any,                 ventura:       "1aa7caddf5a84461d3633f09d878704f395ab7e0467f0817be79cd23ceaa10de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82332e01cda2c06e1d9cc09981c57ab9c00edbf1eb62219ee4b0838ecb821c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a58adf247829574b1deab7b035c71ec60e404e889241dc8e5910458508e09dec"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.14" => :build
  depends_on "libusb"
  depends_on "sdl2"

  pypi_packages package_name:   "",
                extra_packages: "toml"

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def python3
    "python3.14"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources

    system "cmake", "-S", ".", "-B", "build", "-DPython3_EXECUTABLE=#{venv.root}/bin/python", *std_cmake_args
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
