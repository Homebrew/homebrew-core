class Picotool < Formula
  desc "Tool for interacting with RP2040 devices in BOOTSEL mode or RP2040 binaries"
  homepage "https://github.com/raspberrypi/picotool"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/raspberrypi/picotool/archive/refs/tags/1.1.1.tar.gz"
    sha256 "2d824dbe48969ab9ae4c5311b15bca3449f5758c43602575c2dc3af13fcba195"

    resource "pico-sdk" do
      url "https://github.com/raspberrypi/pico-sdk/releases/download/1.5.0/sdk1.5.0-with-submodules.zip"
      sha256 "59a09e619cab67b614d5f4e928a82f6bd055ce6083eb84f1b6caa269f1e3a559"
    end
  end

  head do
    url "https://github.com/raspberrypi/picotool.git", branch: "master"

    resource "pico-sdk" do
      url "https://github.com/raspberrypi/pico-sdk.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  resource "homebrew-pico-blink" do
    url "https://rptl.io/pico-blink"
    sha256 "4b2161340110e939b579073cfeac1c6684b35b00995933529dd61620abf26d6f"
  end

  def install
    resource("pico-sdk").stage buildpath/"pico-sdk"

    args = %W[-DPICO_SDK_PATH=#{buildpath}/pico-sdk]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-pico-blink").stage do
      result = <<~EOS
        File blink.uf2:

        Program Information
         name:      blink
         web site:  https://github.com/raspberrypi/pico-examples/tree/HEAD/blink
      EOS
      assert_equal result, shell_output("#{bin}/picotool info blink.uf2")
    end
  end
end
