class Opencbm < Formula
  desc "Provides access to various floppy drive formats"
  homepage "https://spiro.trikaliotis.net/opencbm-alpha"
  url "https://spiro.trikaliotis.net/Download/opencbm-0.4.99.99/opencbm-0.4.99.99.tar.bz2"
  sha256 "b1e4cd73c8459acd48c5e8536d47439bafea51f136f43fde5a4d6a5f7dbaf6c6"
  head "https://git.code.sf.net/p/opencbm/code.git"

  bottle do
    sha256 "489ae793f9f226c93667cf67f23d7eac1cde97d4ed33549bbe9731fcc824eb2a" => :mojave
    sha256 "d9555da83fc70f801663f13cfc4ed34241feec72d29125fb12a2105fce414210" => :high_sierra
    sha256 "6ff076233d442f7f15e22595623cf46c38cf1024997240bd48db1e4bb01c44c2" => :sierra
    sha256 "6ba3fc869e59f002f6ae897cbb34b4ece023c11371c3d611453b330714b65cba" => :el_capitan
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
