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
    sha256 cellar: :any,                 arm64_ventura:  "ea8a4a04b5cc81eff38d0c5cdfe2fbac519ca2c7652c64371074f4abaf766a0b"
    sha256 cellar: :any,                 arm64_monterey: "ab90516396d8dc99f96d31615bcbddfcfd2082fcc7494dabb9d22b275628e800"
    sha256 cellar: :any,                 arm64_big_sur:  "d9121e56c7dbfad640c9f8e3c3cc621d88404dc1047a4a7b7c82fe06193bca1f"
    sha256 cellar: :any,                 ventura:        "24cdce188aa8b64168774288ccee9546cfacf30b42dbba90ad560b8abea1a639"
    sha256 cellar: :any,                 monterey:       "e79be7d4c611f0017567172771761b1df62d140e79ffa6d2538577eb24a48e44"
    sha256 cellar: :any,                 big_sur:        "963720057ac56afd38f8d4f801f036231f08f5cf7db36cb470814cbc1b38e49c"
    sha256 cellar: :any,                 catalina:       "72ed40aec0356157f3d5071ecb28c481b3f3502985a320ec1848cdc8cf8483c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cae18b6a0315f7e3d8fa8039fd18d6d20fd7f8a0dbb9399e63c95ae0c52fb9d"
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
