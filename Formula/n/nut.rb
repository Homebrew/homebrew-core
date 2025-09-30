class Nut < Formula
  desc "Network UPS Tools: Support for various power devices"
  homepage "https://networkupstools.org/"
  url "https://github.com/networkupstools/nut/releases/download/v2.8.4/nut-2.8.4.tar.gz"
  sha256 "0130ba82ea79f04ba4f34c5249a85943977efd984ed7df6aec1a518d5a3594f8"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "5f1c6d0f04e58c0bbc75e52ec57a65f214140863afacd465f16d98e18bbde5fc"
    sha256 arm64_sequoia: "c6fcd38ac13bedb5bd201fa7967f5988b7d0319e22b1c666769f02bebb13e0d7"
    sha256 arm64_sonoma:  "1642b5fca3794df03bf4ccffae50c8db6c2b58bfb0e226142e888501921e7829"
    sha256 arm64_ventura: "6157ac5ed158623264729d8c8dcbed1e8e01b6c3b98116e4a5f030ad077f47e9"
    sha256 sonoma:        "3f9a548610bd191ea3b910d64621f80b9ef467dfb0c00e3fd5133d3c53c6d7c8"
    sha256 ventura:       "3f056e5ad5607bf0fda058af7753df1780d3044bd2348eb967de9927abc9245c"
    sha256 arm64_linux:   "a494737e49d1ba83ad68616290582803f92d7ea44af2fb6106a69ca72a9174ba"
    sha256 x86_64_linux:  "a4b8b536a16c3c00940dec9e28f7181af84ec01332cb98b7934e925227321fa9"
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
