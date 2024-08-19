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
    sha256 cellar: :any,                 arm64_sonoma:   "54a6d7f18428a643fae21ffc46d69a3452747ff1407ed29327790ad0dad0b1a9"
    sha256 cellar: :any,                 arm64_ventura:  "801089f50337607b35638f59c8b35ccf3483a51f2df4652fa0f87c895043916c"
    sha256 cellar: :any,                 arm64_monterey: "8a0d5976f9b70a6e1b1fe3694a8027791cc045cdf3c5041b50ba8b278632e288"
    sha256 cellar: :any,                 sonoma:         "7b86bb0b04b251f55c8a23c8db28c516f2215fbe41a2d04abcb82e33eb8d1b1e"
    sha256 cellar: :any,                 ventura:        "374296d49a79e319a0b0cb4b99c13e5415a2c6b84291b785e09287c4da41c74c"
    sha256 cellar: :any,                 monterey:       "de0d5fdc80f28ed63a3a4f28dc613e323a4e965907afa4c9fb8fb7bff8166c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b717781f0d4686f32e496614932216b84a9a39bcc95c2eeb2f069afed7a53a73"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.12" => :build
  depends_on "libusb"
  depends_on "sdl2"

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", "python3.12")
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
