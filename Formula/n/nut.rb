class Nut < Formula
  desc "Network UPS Tools: Support for various power devices"
  homepage "https://networkupstools.org/"
  url "https://github.com/networkupstools/nut/releases/download/v2.8.5/nut-2.8.5.tar.gz"
  sha256 "18bf32e59eb764b13da3c4fa70384926d7fa584cb31d2fe7f137a570633eeec1"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "3fe4c8bea0483722456da80d1565be5954b382243d0ca7daa19038d0705f1be9"
    sha256 arm64_sequoia: "d4a4e3998d26057e7bcb24a61469a3dd55e2fe9b102bfa6d6fcb1759b7e28bbe"
    sha256 arm64_sonoma:  "615cc285fc354971ba7b6252e109707ecb7a045a505dca0eb03d4f6cf5fe79aa"
    sha256 sonoma:        "e6b77ad2036fab7be4aa3054ed14112db9b6a4f27d500242b5f989a41982528b"
    sha256 arm64_linux:   "8f5ff079a039c0bd20bf1fb9db3286a82ef5f021e470c8ef30464a225c9b4d5c"
    sha256 x86_64_linux:  "0648f8942e42afe5625ce26a6653fc263de93d5f8c402649b4af60eba88495f6"
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
    depends_on "glib"
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
