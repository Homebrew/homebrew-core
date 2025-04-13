class Nut < Formula
  desc "Network UPS Tools: Support for various power devices"
  homepage "https://networkupstools.org/"
  url "https://github.com/networkupstools/nut/releases/download/v2.8.2/nut-2.8.2.tar.gz"
  sha256 "e4b4b0cbe7dd39ba9097be7f7d787bb2fffbe35df64dff53b5fe393d659c597d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia:  "dbfab84f13ae9c17fe130e2230f7dc957bbd1c01e6cb281fdd03d5cc3e82fc6a"
    sha256 arm64_sonoma:   "43c9c0fc601204d370924ebdfe1a51a68ceec7be66b9cbde21fa748ca705c05f"
    sha256 arm64_ventura:  "5c56ac1e0389d0991c2c94ed36e3cabb5dbedd8b695fa4a9747add1b3eca5c8f"
    sha256 arm64_monterey: "1858aeb052a2b605a7d2ba9f231db1f0d997b9ddeb2da4cabae29520978e57b1"
    sha256 sonoma:         "98df930592937b8cc3c9ed6137c4e3fc6e920d4b3b0122dbb5cd4ceb0c557f0e"
    sha256 ventura:        "80b5f09bfb88e4a7ffa611a3b698385fa4c14a3474ae2f3d270a593276dcf106"
    sha256 monterey:       "17722e1bb6e5e707dc81da194caa13848b035ebf81673261e716d188ef9693c2"
    sha256 arm64_linux:    "38bfb42d6bfb9cf0d158dcdbdf63e61f42240d391702d9d82365c7ad02b4af09"
    sha256 x86_64_linux:   "61047b843accc5c9a8b9de7fb525759445b7e30c07f0a682e06eb32724e96ce1"
  end

  head do
    url "https://github.com/networkupstools/nut.git", branch: "master"
    depends_on "asciidoc" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"
  depends_on "openssl@3"

  on_linux do
    depends_on "systemd"
  end

  conflicts_with "rhino", because: "both install `rhino` binaries"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}/nut
      --with-statepath=#{var}/state/ups
      --with-pidpath=#{var}/run
      --with-systemdtmpfilesdir=#{pkgshare}
      --with-openssl
      --with-serial
      --with-usb
      --without-avahi
      --without-cgi
      --without-dev
      --without-doc
      --without-ipmi
      --without-libltdl
      --without-neon
      --without-nss
      --without-nut_monitor
      --without-powerman
      --without-pynut
      --without-snmp
      --without-wrap
    ]
    args << if OS.mac?
      "--with-macosx_ups"
    else
      "--with-udev-dir=#{lib}/udev"
    end

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"state/ups").mkpath
    (var/"run").mkpath
  end

  service do
    run [opt_sbin/"upsmon", "-D"]
  end

  test do
    system bin/"dummy-ups", "-L"
  end
end
