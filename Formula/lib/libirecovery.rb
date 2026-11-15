class Libirecovery < Formula
  desc "Library and utility to talk to iBoot/iBSS via USB"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libirecovery/releases/download/1.3.1/libirecovery-1.3.1.tar.bz2"
  sha256 "28a3a521782063c8eb2ee5f4c0f38a517e023853edb55856052cdd7ac400381b"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/libimobiledevice/libirecovery.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a431276c56c97f47113f2d7cfdae91dd54cb9f55be9a7b38b23c2c2457fa9cd4"
    sha256 cellar: :any, arm64_tahoe:       "c1f363151a9d348e0a64e4700aced724a23592d19697b0d04c946c4c5684720d"
    sha256 cellar: :any, arm64_sequoia:     "7f29e556e43714b684ff38a39f17252a7b6045eeeb8bb2f519c3223ec4605601"
    sha256 cellar: :any, arm64_linux:       "4b66e902d9548f4eda08653150c02b3f61bdc54df604d9534fed5bd36dbcc49c"
    sha256 cellar: :any, x86_64_linux:      "4cf7d2482b31099c176efdc905144a371df121d0db6db8eee1737642fb6ce76a"
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
