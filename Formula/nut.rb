class Nut < Formula
  desc "Network UPS Tools: Support for various power devices"
  homepage "https://networkupstools.org/"
  license "GPL-2.0-or-later"

  stable do
    url "https://networkupstools.org/source/2.8/nut-2.8.0.tar.gz"
    sha256 "c3e5a708da797b7c70b653d37b1206a000fcb503b85519fe4cdf6353f792bfe5"

    # fix build failure
    # remove in next release
    patch do
      url "https://github.com/networkupstools/nut/commit/9e6d3c79a4c0ed71c25fdfd350402bb2e78e42e8.patch?full_index=1"
      sha256 "39472a04f1963a297713381a3a17e57183c1143a6602c194ca3016244caa6a9f"
    end
  end

  livecheck do
    url "https://networkupstools.org/download.html"
    regex(/href=.*?nut[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "de8faf2fdb4127d92e1e0df5289d485b7936da149055fefb136f23978da49c4b"
    sha256 arm64_big_sur:  "5f500dadf3f80933b8e36bb5570aea8a29a06e81e576fcd4e5680793d7506ba9"
    sha256 monterey:       "8f701b356d7b8989344e2238497c016ff72de395d4dd0feb037b1713b6b24ee9"
    sha256 big_sur:        "38d910d0eb58cccc15593aa6675aa9547710e88c39c31849053a48bcc9ec972d"
    sha256 catalina:       "b77e56263a12f2159bce36d8d4e27ca87bc8b9d855e204051b4726237c06899f"
    sha256 mojave:         "357f99b63af4a81516fb8e1775f3569aeed577e62bad7906136bd9f0906e7184"
    sha256 x86_64_linux:   "ad7dfc16b500f03bbead324d23ddc4125ba416a504a5bc81e9515d807a741669"
  end

  head do
    url "https://github.com/networkupstools/nut.git", branch: "master"
    depends_on "asciidoc" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb-compat"
  depends_on "openssl@1.1"

  conflicts_with "rhino", because: "both install `rhino` binaries"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
      system "./autogen.sh"
    else
      # Regenerate configure, due to patch applied
      system "autoreconf", "-i"
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
      --without-powerman
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
    system "#{bin}/dummy-ups", "-L"
  end
end
