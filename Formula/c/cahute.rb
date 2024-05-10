class Cahute < Formula
  include Language::Python::Virtualenv

  desc "Library and set of utilities to interact with Casio calculators"
  homepage "https://cahuteproject.org/"
  url "https://ftp.cahuteproject.org/releases/cahute-0.4.tar.gz"
  sha256 "a178389ac82e2e83cd55d8d80ee1771daae88331a0e799d5573d986428825648"
  license "CECILL-2.1"

  livecheck do
    url "https://ftp.cahuteproject.org/releases/"
    regex(/href=.*?cahute[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2bdbb8f9a3a96e4464e4198b967d978495a0c5777ba60c056a651f7b159d43a8"
    sha256 cellar: :any,                 arm64_ventura:  "f77183811692e901e0137ff22a56393bfbc98b5865c49024bbcb5e6979699ed2"
    sha256 cellar: :any,                 arm64_monterey: "6bfdbc3ab88c8dd88af56205e18834212fa457c5e3766f041f046690024baa0e"
    sha256 cellar: :any,                 sonoma:         "fe98c279c43a8782bd8384a68a4e18bf45006ed2509da114086d67352b821f2f"
    sha256 cellar: :any,                 ventura:        "22f99a9106482a5ed4972667491e6ce853f0451ec33e615d35f313e007ed28ea"
    sha256 cellar: :any,                 monterey:       "161ea8710adc8997525d327d4b3d939d21c42888096cdbba41b553ecc5fe7dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ce0312a62d15a5b1f26391bd53c599805447e9f30a425699a5894979ee9a00c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.12" => :build
  depends_on "libusb"
  depends_on "sdl2"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/d6/4f/b10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aed/setuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", "python3.12")
    venv.pip_install resources

    system "cmake", "-S", ".", "-B", "build", "-DPython3_EXECUTABLE=#{buildpath}/venv/bin/python", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Assume that there is no calculator connected while testing
    assert_match "Could not connect to the calculator.", shell_output("#{bin}/p7 idle 2>&1", 1)
    assert_match "Could not connect to the calculator.", shell_output("#{bin}/p7screen 2>&1", 1)

    # xfer9860 is a reimplementation of an older program of the same name, which does not indicate
    # a failure exit code when a calculator isn't present. So here, we expect a successful exit
    # status but an error message printed to the console.
    assert_match "Could not connect to the calculator.", shell_output("#{bin}/xfer9860 -i 2>&1")

    # No calculator is connected, so this will also fail. Any test file will do.
    shell_output("#{bin}/p7os flash #{test_fixtures "test.ico"} 2>&1", 1)

    # Taken from https://cahuteproject.org/developer-guides/detection/usb.html
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

    pkg_config_cflags = shell_output("pkg-config --cflags --libs cahute libusb-1.0").strip.split
    system ENV.cc, "usb-detect.c", *pkg_config_cflags, "-o", "usb-detect"
    system "./usb-detect"
  end
end
