class Picotool < Formula
  desc "Tool for interacting with RP2040/RP2350 devices and binaries"
  homepage "https://github.com/raspberrypi/picotool"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/raspberrypi/picotool/archive/refs/tags/2.3.0.tar.gz"
    sha256 "97aaf36800d2317683528cba5762e3d4e7a5de0cba729d28011a6ee94b3b7538"

    resource "pico-sdk" do
      # Use git checkout to allow fetching mbedtls submodule
      url "https://github.com/raspberrypi/pico-sdk.git",
          tag:      "2.3.0",
          revision: "98a542c1a62fb549ffb5d66a3e5892b06276b670"

      livecheck do
        formula :parent
      end
    end
  end

  bottle do
    sha256 arm64_tahoe:   "4bd285ece87f46f5cb4246897c5841f23b7e9496497cad36628125e704a7084f"
    sha256 arm64_sequoia: "fec365c2892ad427846efc7fc0e4c4308bba4707e36fc0bd6cdf5a28bcf4a67d"
    sha256 arm64_sonoma:  "019117ac178f54c58722ff1a401d6d8de12d6ff615accb48c8ce110db0f08796"
    sha256 sonoma:        "ca3973e3d44fe2826c86f5b55abbb3bfe0f769dcc78eb9105bcc6286eb21859b"
    sha256 arm64_linux:   "6cd1d212f061779ae3a341aab7811c3daf17c1f4f3397546d2ead512dea5691e"
    sha256 x86_64_linux:  "a437179a646290aa7fedaee69c0d0f486882ed043d8633d85a4635fb1b96b4c0"
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
    resource "homebrew-blink_universal" do
      url "https://datasheets.raspberrypi.com/soft/blink_picow.uf2"
      sha256 "e8f8e578129ebded860ae019288b282b0a620f5ac2dfc49adedc565c73e6ad22"
    end

    resource("homebrew-blink_universal").stage do
      result = <<~EOS
        File blink_universal.uf2 family ID 'rp2040':

        Program Information
         name:          blink_universal
         web site:      https://github.com/raspberrypi/pico-examples/tree/HEAD/universal/blink_universal
         binary start:  0x10000000
         binary end:    0x100407bc
      EOS
      assert_equal result, shell_output("#{bin}/picotool info blink_universal.uf2")
    end
  end
end
