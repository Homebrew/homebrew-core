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

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d56b7760c3d5a77669d1e69ebf3dbdac4b0d6680d01d438bb447bf0c09aa549e"
    sha256 cellar: :any,                 arm64_monterey: "6cf9bc19040bbcdfb70a6ea547c22a6480f53168f68fcd8474f45f8701cf03c3"
    sha256 cellar: :any,                 arm64_big_sur:  "573308465e29e22d7ea592aa0a835f861695921194432feb9a69fc99b93aab62"
    sha256 cellar: :any,                 ventura:        "4d5d2046ad99ada6f69ca50ad8bc8f08c2b33ec6082c9395d3ec8de4735c4da9"
    sha256 cellar: :any,                 monterey:       "62f2fc8a6f196cbf98f6fbc1d5807c933cf695511e8a9258cc46cb727426a58f"
    sha256 cellar: :any,                 big_sur:        "18791cd0bf1b69a5215d232f56425a02b4d44a890f3af087931b8e287f32c0f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a50cabfece6ec443857dc7290ea69bdf5ca889cccc610c8043f954cf061c8e0b"
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
