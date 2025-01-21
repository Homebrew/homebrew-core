class Libusb < Formula
  desc "Library for USB device access"
  homepage "https://libusb.info/"
  url "https://github.com/libusb/libusb/releases/download/v1.0.27/libusb-1.0.27.tar.bz2"
  sha256 "ffaa41d741a8a3bee244ac8e54a72ea05bf2879663c098c82fc5757853441575"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "872182eebb566f32d577fa82b126260c383c6a8f8d02e9fc232eadda9184060b"
    sha256 cellar: :any,                 arm64_sonoma:   "fff3e66328455513a887dd4e8043a13a1213035f7e4a757d4fdf93f9815ffd1d"
    sha256 cellar: :any,                 arm64_ventura:  "5d14898869c8bb7d12f6a8091b16c2db76909293b579d10b0ee846248451a765"
    sha256 cellar: :any,                 arm64_monterey: "05c5363ff9f8a4aeaf65eb3f95fba3a4fc7f665d35a627a2d212c43fb7ad5838"
    sha256 cellar: :any,                 sonoma:         "e49b076581da7311e8a724c409fa12a76a948e1e6805022d4e3cbca6af2c946a"
    sha256 cellar: :any,                 ventura:        "4f8f2015115cc18610ff65a9f0f34589ebd9596b929066867bbbcac18977b689"
    sha256 cellar: :any,                 monterey:       "e02e54902348f1918adf758a6b2f4c5d113570f4c98e9f0a38b8d3b24c50c942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8a4b5075fbdaf5dca99d33fc5d1f21bf45832dcb3a98267737ebc3cd9e55515"
  end

  head do
    url "https://github.com/libusb/libusb.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "systemd"
  end

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
    (pkgshare/"examples").install Dir["examples/*"] - Dir["examples/Makefile*"]
  end

  test do
    cp_r (pkgshare/"examples"), testpath
    cd "examples" do
      system ENV.cc, "listdevs.c", "-L#{lib}", "-I#{include}/libusb-1.0",
             "-lusb-1.0", "-o", "test"
      system "./test"
    end
  end
end
