class Opencbm < Formula
  desc "Provides access to various floppy drive formats"
  homepage "http://www.trikaliotis.net/opencbm-alpha"
  url "http://www.trikaliotis.net/Download/opencbm-0.4.99.99/opencbm-0.4.99.99.tar.bz2"
  sha256 "b1e4cd73c8459acd48c5e8536d47439bafea51f136f43fde5a4d6a5f7dbaf6c6"
  head "https://git.code.sf.net/p/opencbm/code.git"

  bottle do
    sha256 "5da290f387b5cdf7fb60043fcc6aea4bd59d0ece756caf5d3180bd08ab254df7" => :high_sierra
    sha256 "b259c17a32d88330c3c68c1808556332c085fd4556780a3399a63d1e196b6047" => :sierra
    sha256 "37ba85e14c150298282184e951463d6f144e254552b02989d37fda2b73048bab" => :el_capitan
    sha256 "ebae0f7ec2738011329779d8bb419838ad11bb6397e687f0ea43ae12ad6df259" => :yosemite
    sha256 "a717325f45b16e0565167221054589fe37ed9d8c90e5cff63a41ebb2ced343d3" => :mavericks
  end

  # cc65 is only used to build binary blobs included with the programs; it's
  # not necessary in its own right.
  depends_on "cc65" => :build
  depends_on "libusb-compat"

  # Fix "usb_echo_test.c:32:10: fatal error: 'endian.h' file not found"
  # Reported 24 Nov 2017 to www-201506 AT spiro DOT trikaliotis DOT net
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/48bd0fd/opencbm/endian.diff"
    sha256 "2221fab81cdc0ca0cfbd55eff01ae3cd10b4e8bfca86082c7cbffb0b73b651cf"
  end

  def install
    # This one definitely breaks with parallel build.
    ENV.deparallelize

    args = %W[
      -fLINUX/Makefile
      LIBUSB_CONFIG=#{Formula["libusb-compat"].bin}/libusb-config
      PREFIX=#{prefix}
      MANDIR=#{man1}
    ]

    system "make", *args
    system "make", "install-all", *args
  end

  test do
    system "#{bin}/cbmctrl", "--help"
  end
end
