class Libirecovery < Formula
  desc "Library and utility to talk to iBoot/iBSS via USB"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libirecovery/releases/download/1.4.0/libirecovery-1.4.0.tar.bz2"
  sha256 "ea358430fdcedc00ae7d5764b3d03737f7345c91364fb91271bc6ceeee5d9cac"
  license "LGPL-2.1-only"
  head "https://github.com/libimobiledevice/libirecovery.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "d4efa47a1f8b3f6f880075098a71f7e7ad71abaf49b723d6c848962c6fe16b50"
    sha256 arm64_tahoe:       "28c6f513e78ac8c5a11b6f8288e2cdeb1de71d5de850beaade5f705414df9385"
    sha256 arm64_sequoia:     "a834994f2c368e3aa99f4ea11d2f8fd451b113f14ff9e45d4f3191cf58ab11dd"
    sha256 arm64_linux:       "93ae1e2a684798a33c7f0658f00e8edb10668a7463d9bb8d7eeb7331499dc485"
    sha256 x86_64_linux:      "fa51153d639af209b1dc4c9b2986852763032af27a420b0f41d4d3863fc65d8f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libimobiledevice-glue"

  on_macos do
    depends_on "libplist"
  end

  on_linux do
    depends_on "libusb"
    depends_on "readline"
  end

  deny_network_access!

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"

    args = ["--with-udevrulesdir=#{lib}/udev/rules.d"] if OS.linux?
    system configure, "--disable-silent-rules", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "ERROR: Unable to connect to device", shell_output("#{bin}/irecovery -f nothing 2>&1", 255)
  end
end
