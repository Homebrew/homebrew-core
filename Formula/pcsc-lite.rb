class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-1.9.8.tar.bz2"
  sha256 "502d80c557ecbee285eb99fe8703eeb667bcfe067577467b50efe3420d1b2289"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "145b3ebbe42e46c92d8eec4cad02cab82dbaa9b4097fa9d03858c32d12dcc9c8"
    sha256 cellar: :any,                 arm64_big_sur:  "dbbc8568a8b8050ef9111fe8a609789c0b223aca457529dd681dbb6a539ea7d7"
    sha256 cellar: :any,                 monterey:       "810bf27931157dab2015e164216d9d4a686805dfe3c47b2c0794a46fbcb792f2"
    sha256 cellar: :any,                 big_sur:        "61a8d19808ab9ee3c58191843ea8daa8e9eab5603797a30eb9ea5b2d96a89268"
    sha256 cellar: :any,                 catalina:       "c29b451350f63edfd4931aa52132defcf48914b21442c093f2575dfe28c8f350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa7c12525da58a50e43b8318a82e0c7033f67c88132d0c452b8a1c5942c82c3c"
  end

  keg_only :shadowed_by_macos, "macOS provides PCSC.framework"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libusb"
  end

  def install
    args = %W[--disable-dependency-tracking
              --disable-silent-rules
              --prefix=#{prefix}
              --sysconfdir=#{etc}
              --disable-libsystemd]

    args << "--disable-udev" if OS.linux?

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
