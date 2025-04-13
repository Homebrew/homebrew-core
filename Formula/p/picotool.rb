class Picotool < Formula
  desc "Tool for interacting with RP2040/RP2350 devices and binaries"
  homepage "https://github.com/raspberrypi/picotool"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/raspberrypi/picotool/archive/refs/tags/2.1.1.tar.gz"
    sha256 "19200c6dc4be5acd6fb53de3d7f35c826af596c18879d56f214b795300100260"

    resource "pico-sdk" do
      url "https://github.com/raspberrypi/pico-sdk/archive/refs/tags/2.1.1.tar.gz"
      sha256 "179c5531e75ac7f82d0679e70b6e8881f871738dc0ef17baf3b4ff4679291c41"

      livecheck do
        formula :parent
      end
    end
  end

  bottle do
    sha256 arm64_sequoia: "8e51e1b6845de5e0b23a077e14d62833a1a278dd152af0c3dfef5e61cc2256b5"
    sha256 arm64_sonoma:  "cd8546607360520cf90fb05023ddedf4314f5091a405b26a14258671de27d43f"
    sha256 arm64_ventura: "d4f3ee5104586f5333b44791ddab8cb73335674e9c34bba6087ac2b5173977bb"
    sha256 sonoma:        "5a30e1353a4d3ab7d2dfc5ceb9e129e24d5909fd2a78e49a15f440c47d99b832"
    sha256 ventura:       "968e9358bedbeb778f48ceea8aac90f86be7166073f560273a4a1175a17a1f74"
    sha256 arm64_linux:   "238fcbc4f902a9f507d68e3f8a4988ae59b04e7cff40ab729d6eddc57d6f9643"
    sha256 x86_64_linux:  "e1eedbfbeb6bbd81d3e6bdf3e3c086ef33689ea341967e00b1cdeef528f77ce8"
  end

  head do
    url "https://github.com/raspberrypi/picotool.git", branch: "master"

    resource "pico-sdk" do
      url "https://github.com/raspberrypi/pico-sdk.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  def install
    odie "pico-sdk resource needs to be updated" if build.stable? && version != resource("pico-sdk").version

    resource("pico-sdk").stage buildpath/"pico-sdk"

    args = %W[-DPICO_SDK_PATH=#{buildpath}/pico-sdk]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # from https://github.com/raspberrypi/pico-examples?tab=readme-ov-file#first-examples
    resource "homebrew-picow_blink" do
      url "https://rptl.io/pico-w-blink"
      sha256 "ba6506638166c309525b4cb9cd2a9e7c48ba4e19ecf5fcfd7a915dc540692099"
    end

    resource("homebrew-picow_blink").stage do
      result = <<~EOS
        File blink_picow.uf2 family ID 'rp2040':

        Program Information
         name:          picow_blink
         web site:      https://github.com/raspberrypi/pico-examples/tree/HEAD/pico_w/blink
         features:      UART stdin / stdout
         binary start:  0x10000000
         binary end:    0x1003feac
      EOS
      assert_equal result, shell_output("#{bin}/picotool info blink_picow.uf2")
    end
  end
end
