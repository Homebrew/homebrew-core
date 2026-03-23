class Picotool < Formula
  desc "Tool for interacting with RP2040/RP2350 devices and binaries"
  homepage "https://github.com/raspberrypi/picotool"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/raspberrypi/picotool/archive/refs/tags/2.2.0.tar.gz"
    sha256 "aab3d82fb1e576d97156ddcb962ae7cf290518a5f20d9002ac27e628dc657620"

    resource "pico-sdk" do
      # Use git checkout to allow fetching mbedtls submodule
      url "https://github.com/raspberrypi/pico-sdk.git",
          tag:      "2.2.0",
          revision: "a1438dff1d38bd9c65dbd693f0e5db4b9ae91779"

      livecheck do
        formula :parent
      end
    end
  end

  bottle do
    sha256 arm64_tahoe:   "b12cf07252361b521281cf7602d0ab010555d02abac576e1ce3be340df4d66c7"
    sha256 arm64_sequoia: "49cb6c6d41e91089a09df5bf092d83d658f5db22490e391134e9c9ead450f0f8"
    sha256 arm64_sonoma:  "2159fc13efa5a87797d8d6d0ded1647cef3c78cbf41c83fbb18294e48f81b0cb"
    sha256 arm64_ventura: "7025bf2422beece703941ecd4cafd63f2f7ec104a91197970e9a2be19f0f9bf1"
    sha256 sonoma:        "08e87accab4171dd4d3fbd0fc2d68ba6b4212281f39664c0d6e833f2b76acdc7"
    sha256 ventura:       "74c24dc9a56d7e5f3302c665452a5a0151be7554b4442eb2ba49910513ebbfc8"
    sha256 arm64_linux:   "d0019fa8d364fc028d890587caca5944c3f49eaa559f3e4076fefe2b347e9fbd"
    sha256 x86_64_linux:  "3a7872893bf73e1fa954822415d7f3dbb72d16a83899635fe091d0adb1454994"
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
