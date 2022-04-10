class Libusb < Formula
  desc "Library for USB device access"
  homepage "https://libusb.info/"
  url "https://github.com/libusb/libusb/releases/download/v1.0.26/libusb-1.0.26.tar.bz2"
  sha256 "12ce7a61fc9854d1d2a1ffe095f7b5fac19ddba095c259e6067a46500381b5a5"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ff2e884605bc72878fcea2935e4c001e4abd4edf97996ea9eaa779557d07983d"
    sha256 cellar: :any,                 arm64_big_sur:  "f9b75776c0b3b7fa44eb9876e4b102efdefffd432f019bc6a526e28d82eec991"
    sha256 cellar: :any,                 monterey:       "95c09d4f1f6e7a036b8d09a5ced561c0b8be29e6caa06030624e77f10ad2521a"
    sha256 cellar: :any,                 big_sur:        "742a3d523988790f967df5c944b802a8d8f536a99fab123e823acbd6b1ce4fde"
    sha256 cellar: :any,                 catalina:       "e202da5a53b0955b4310805b09e9f4af3b73eed57de5ae0d44063e84dca5eafd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecdc26816b95a604c156e32005b2199ebef9d17e6ec7ce4537bec2f3dfeb20ee"
  end

  head do
    url "https://github.com/libusb/libusb.git"

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
