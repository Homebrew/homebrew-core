class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https://flashrom.org/"
  license "GPL-2.0-or-later"
  revision 1
  head "https://review.coreboot.org/flashrom.git", branch: "master"

  stable do
    url "https://download.flashrom.org/releases/flashrom-v1.2.tar.bz2"
    sha256 "e1f8d95881f5a4365dfe58776ce821dfcee0f138f75d0f44f8a3cd032d9ea42b"

    # Add https://github.com/flashrom/flashrom/pull/212, to allow flashrom to build on Apple Silicon
    patch do
      url "https://github.com/areese/flashrom/commit/0c7b279d78f95083b686f6b1d4ce0f7b91bf0fd0.patch?full_index=1"
      sha256 "9e1f54f7ae4e67b880df069b419835131f72d166b3893870746fff456b0b7225"
    end
  end

  livecheck do
    url "https://download.flashrom.org/releases/"
    regex(/href=.*?flashrom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "df1dc0950b4c27eba7ca248b0ec0d8f6b72b3b1db87ad4bc6df85f9df36c62cf"
    sha256 cellar: :any,                 arm64_monterey: "ce92fbb333453ecfa68d81e86b56cee5890df50f3cf25055feda05b3337943fe"
    sha256 cellar: :any,                 arm64_big_sur:  "569c926b496c0710fb7ba56741ec71b0907225496be2d0e3f00abb31f6f78753"
    sha256 cellar: :any,                 monterey:       "7880c53527b2b99af980f238cd47973f252472440f80ccb33e850f4e8535c292"
    sha256 cellar: :any,                 big_sur:        "5f87947474ca85777550cb5223e90c5bc9df115432dac3c16a71ac69f47ab3c8"
    sha256 cellar: :any,                 catalina:       "3d13587cb5057ef4ca331156e13a235cf25517fe7fe65d9c134394be1c408400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9943440449dc40ac90fca72ba2d125941d60f5d3395ad555422f754bbe0c768b"
  end

  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"

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
