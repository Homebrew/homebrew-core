class Libbladerf < Formula
  desc "USB 3.0 Superspeed Software Defined Radio Source"
  homepage "https://nuand.com/"
  url "https://github.com/Nuand/bladeRF.git",
      tag:      "2021.02",
      revision: "3b4f42dee4300669d58718df4b85616a85b64904"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://github.com/Nuand/bladeRF.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_big_sur: "8aad9ec5a110be875915aefb2eb22a0027939aa41c9f19beacf369990012c96b"
    sha256                               big_sur:       "7f31ea534f7b3e45b6aa757e437a81e463b88adead45f70583de6528c8d07c1c"
    sha256                               catalina:      "6f663f523dfb1cada7a8637c2a8715f7da520fd7c53872a97212f776ca7639d9"
    sha256                               mojave:        "6cf6caa846b8cab56722c692912e37485598d7bc415ffbe722e961bb1f219cff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d8bfc858fbdd0a9c6b98ad595e0aae81bbf22286df3e73f994ce3d6617d020f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    on_macos { ENV.prepend "CFLAGS", "-I#{MacOS.sdk_path}/usr/include/malloc" }
    mkdir "host/build" do
      system "cmake", "..", *std_cmake_args, "-DUDEV_RULES_PATH=#{lib}/udev/rules.d"
      system "make", "install"
    end
  end

  test do
    system bin/"bladeRF-cli", "--version"
  end
end
