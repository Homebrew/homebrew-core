class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https://flashrom.org/"
  url "https://download.flashrom.org/releases/flashrom-v1.2.tar.bz2"
  sha256 "e1f8d95881f5a4365dfe58776ce821dfcee0f138f75d0f44f8a3cd032d9ea42b"
  license "GPL-2.0"
  revision 1
  head "https://review.coreboot.org/flashrom.git", branch: "master"

  livecheck do
    url "https://download.flashrom.org/releases/"
    regex(/href=.*?flashrom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c5348e8e2eee03d4b47ce1e337c46a0f87495c163b2bf58dfdf5e16ba8d09c1d"
    sha256 cellar: :any,                 arm64_big_sur:  "fe1293f2942b24f63cc8d1e39b0d61c509bf2c57071e5d009f77f6a7d48390a4"
    sha256 cellar: :any,                 monterey:       "ba31b7f7e2609f3687ae42843791dcd292bd8535bbbf003272ad7e54bac578e7"
    sha256 cellar: :any,                 big_sur:        "d4676d20d23ff56628635ddc049721168f0d9ad945ccd09096001d886eed0321"
    sha256 cellar: :any,                 catalina:       "a3f2b538040d6f64ae7f2d827e298e8eb2e954676920449c7cd71be642597c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "175960b96ea9c036dd4062fef8f37d220219b38e840ef1080e1110732a76096a"
  end

  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"

  # Add https://github.com/flashrom/flashrom/pull/212, to allow flashrom to build on Apple Silicon
  patch do
    url "https://github.com/areese/flashrom/commit/0c7b279d78f95083b686f6b1d4ce0f7b91bf0fd0.patch?full_index=1"
    sha256 "9e1f54f7ae4e67b880df069b419835131f72d166b3893870746fff456b0b7225"
  end

  def install
    ENV["CONFIG_RAYER_SPI"] = "no"
    ENV["CONFIG_ENABLE_LIBPCI_PROGRAMMERS"] = "no"

    system "make", "DESTDIR=#{prefix}", "PREFIX=/", "install"
    mv sbin, bin
  end

  test do
    system bin/"flashrom", "--version"
  end
end
