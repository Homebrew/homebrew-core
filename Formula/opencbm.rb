class Opencbm < Formula
  desc "Provides access to various floppy drive formats"
  homepage "https://spiro.trikaliotis.net/opencbm"
  url "https://github.com/OpenCBM/OpenCBM/archive/v0.4.99.104.tar.gz"
  sha256 "5499cd1143b4a246d6d7e93b94efbdf31fda0269d939d227ee5bcc0406b5056a"
  license "GPL-2.0-only"
  head "https://git.code.sf.net/p/opencbm/code.git", branch: "master"

  livecheck do
    url :homepage
    regex(/<h1[^>]*?>VERSION v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_ventura:  "735513b4928af4c14803fc656d7c6d7db607e41e0eef128f0bbd3ae94ab1cb0f"
    sha256 arm64_monterey: "7a9045bbeb039a0780d82105d34db267b90bc25149a3a5ef6f09fbe9d5668c3f"
    sha256 arm64_big_sur:  "5ccc1506a1b20e7b17fcea1eac1a6af5cc4cc55f7be4c91e99d36f2daf6c4ea8"
    sha256 ventura:        "01fd967c187d6386e2d162174599eb1ddf3f5de8250d213d8fcf6e8b19bca83b"
    sha256 monterey:       "d650f6b29d9bb6e28834ae32065a1589ec06ca738ebf615ea3a62109442abde6"
    sha256 big_sur:        "f1843a75ae047aa93f9e6614462fabc2f87691fb977487c2e5db92f3b78a0aa5"
    sha256 catalina:       "455a3ac134295766c1752bd861ab6109262e3dd780751d5227219c9970226640"
    sha256 x86_64_linux:   "4526b2743b3a0ff4cf54f874099bb2f8c1779f709f7b97ba156796e7db504449"
  end

  # cc65 is only used to build binary blobs included with the programs; it's
  # not necessary in its own right.
  depends_on "cc65" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    # This one definitely breaks with parallel build.
    ENV.deparallelize

    args = %W[
      -fLINUX/Makefile
      LIBUSB_CONFIG=#{Formula["libusb-compat"].bin}/libusb-config
      PREFIX=#{prefix}
      MANDIR=#{man1}
      ETCDIR=#{etc}
      UDEVRULESDIR=#{lib}/udev/rules.d
      LDCONFIG=
    ]

    system "make", *args
    system "make", "install-all", *args
  end

  test do
    system "#{bin}/cbmctrl", "--help"
  end
end
