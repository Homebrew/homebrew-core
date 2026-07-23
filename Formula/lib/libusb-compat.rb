class LibusbCompat < Formula
  desc "Library for USB device access"
  homepage "https://libusb.info/"
  url "https://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.9/libusb-compat-0.1.9.tar.bz2"
  sha256 "179d934676ad3bd172a5a37cf5c6351b8e9d7816feb3029252e79b30a518a3be"
  license all_of: [
    "LGPL-2.1-or-later",
    any_of: ["LGPL-2.1-or-later", "BSD-3-Clause"], # libusb/usb.h
  ]
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/libusb-compat[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ede303d531c123cd3a5e6c118d0ce048ef9388cc16299e0185b3c1569d7d201d"
    sha256 cellar: :any,                 arm64_sequoia: "5edda2497fe18ce3d0ffaf638b8b2d78bbb2adcfe17aee9f609ff43866df2a34"
    sha256 cellar: :any,                 arm64_sonoma:  "e6d7d51c7b6152519f6bd17ab490935ba730cd73f4125f9734790ab79bc15354"
    sha256 cellar: :any,                 sonoma:        "f5c9946de1037ea59449aaac808e70f5e6fd8e64c9526efd89ad3697f61fb81e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a81d5b98d61c2fc5ae6eabd7136cf2b81b1cf8dcc26acd78eb41c20d8a604771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92792cb202445badf8ca6ed59b0c3b5397d1e63452abed9d34fef5ebd970466b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"libusb-config", "--libs"
  end
end
