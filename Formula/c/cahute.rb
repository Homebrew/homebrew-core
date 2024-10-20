class Cahute < Formula
  include Language::Python::Virtualenv

  desc "Library and set of utilities to interact with Casio calculators"
  homepage "https://cahuteproject.org/"
  url "https://ftp.cahuteproject.org/releases/cahute-0.5.tar.gz"
  sha256 "6206d8d9e2557dffa80a435ce96574c1bb2db16bc422afae8084d611963a2ba9"
  license "CECILL-2.1"
  head "https://gitlab.com/cahuteproject/cahute.git", branch: "develop"

  livecheck do
    url "https://ftp.cahuteproject.org/releases/"
    regex(/href=.*?cahute[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "4e87caab9efe6bbafa902f326b7f970ecb544b7ceb6dde814ad297052df9180d"
    sha256 cellar: :any,                 arm64_sonoma:  "76c9b13ca029fc173d1b2a5cade69f65553df52b66939b85890d67af1d3fd281"
    sha256 cellar: :any,                 arm64_ventura: "f4ddd7874435b2aea256f2c18d873ac6c1245e1111e329dde59829aeec68723b"
    sha256 cellar: :any,                 sonoma:        "29963eec6d0daaff4836ad997cd9dfb711218bf4a954dda8d6e79d6c90843595"
    sha256 cellar: :any,                 ventura:       "40d37194e9d0335d990f2ebadf5d735edfe5cfee429b92b1b37d5da3e9884d85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f12f31c6f31c3a10bac5b6de716a73ad70778f0c764e3cbd0cdc2b870d81c1e6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.13" => :build
  depends_on "libusb"
  depends_on "sdl2"

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def python3
    "python3.13"
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
    C

    pkg_config_cflags = shell_output("pkg-config --cflags --libs cahute libusb-1.0").strip.split
    system ENV.cc, "usb-detect.c", *pkg_config_cflags, "-o", "usb-detect"
    system "./usb-detect"
  end
end
