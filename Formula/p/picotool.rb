class Picotool < Formula
  desc "Tool for interacting with RP2040/RP2350 devices and binaries"
  homepage "https://github.com/raspberrypi/picotool"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/raspberrypi/picotool/archive/refs/tags/2.1.0.tar.gz"
    sha256 "9062fea171661c6aa13294e092f0dc92641382d2b6f95315529bfbe9fb1521e4"

    resource "pico-sdk" do
      url "https://github.com/raspberrypi/pico-sdk/archive/refs/tags/2.1.0.tar.gz"
      sha256 "5e3abc511955dd2179809d0c33f05fe6f94544d8d0ca436842e6638bb655d4d2"
    end
  end

  bottle do
    sha256 arm64_sequoia: "9f18704812babde0c3ada9b4b7b0639517e168531a9775f5f31eeb8f57d9d83a"
    sha256 arm64_sonoma:  "bf230f25264224a7a1dd23a130d26fb99fa1420fed1541aaef83fcf3a35957e5"
    sha256 arm64_ventura: "d3cecbf0608f1bcf0335b36e9ab90770a3f1499b76166e23bee84228c6ffbc62"
    sha256 sonoma:        "cfe0c43600912bd4dbeab08ed2527bb06344ccefdc65762184995eee828ec15c"
    sha256 ventura:       "9084cfd0418efff106d863b5a482d9e0e439c0a6385642752bc28c7e43df702a"
    sha256 x86_64_linux:  "585aa0ccd95425b82848f4cdf9410a96da20c02bf46ec6ec32c88a170539209c"
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
