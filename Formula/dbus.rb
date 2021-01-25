class Dbus < Formula
  # releases: even (1.12.x) = stable, odd (1.13.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.12.20.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/d/dbus/dbus_1.12.20.orig.tar.gz"
  sha256 "f77620140ecb4cdc67f37fb444f8a6bea70b5b6461f12f1cbe2cec60fa7de5fe"

  livecheck do
    url :head
    regex(/^dbus[._-]v?(\d+\.\d*?[02468](?:\.\d+)*)$/i)
  end

  bottle do
    sha256 "e3ff464367ad79df35c0f81d70a58607a174e9fa63cd507b575f0988ec913b7d" => :big_sur
    sha256 "98319ca7d3dda690a932243a20a1ebaebe89e2386282bad7232f842f2abecbc5" => :arm64_big_sur
    sha256 "23513ea5d75203fe4374ab37cc4226f23f34ec604449ef572fd6a2b48a612ff3" => :catalina
    sha256 "912da7c3211a981762dc45e4f67fbedd1afd379459a40244340c83caa4134382" => :mojave
    sha256 "6c98efff3cb8fdbba552351a2953f85953f053e12a8af891461118d37affdb73" => :high_sierra
  end

  head do
    url "https://gitlab.freedesktop.org/dbus/dbus.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "xmlto" => :build

  uses_from_macos "expat"

  on_linux do
    depends_on "pkg-config" => :build
  end

  # Patch applies the config templating fixed in https://bugs.freedesktop.org/show_bug.cgi?id=94494
  # Homebrew pr/issue: 50219
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0a8a55872e/d-bus/org.freedesktop.dbus-session.plist.osx.diff"
    sha256 "a8aa6fe3f2d8f873ad3f683013491f5362d551bf5d4c3b469f1efbc5459a20dc"
  end

  def install
    # Fix the TMPDIR to one D-Bus doesn't reject due to odd symbols
    ENV["TMPDIR"] = "/tmp"

    # macOS doesn't include a pkg-config file for expat
    ENV["EXPAT_CFLAGS"] = "-I#{MacOS.sdk_path}/usr/include"
    ENV["EXPAT_LIBS"] = "-lexpat"

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./autogen.sh", "--no-configure" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--enable-xml-docs",
                          "--disable-doxygen-docs",
                          "--enable-launchd",
                          "--with-launchd-agent-dir=#{prefix}",
                          "--without-x",
                          "--disable-tests"
    system "make", "install"
  end

  def plist_name
    "org.freedesktop.dbus-session"
  end

  def post_install
    # Generate D-Bus's UUID for this machine
    system "#{bin}/dbus-uuidgen", "--ensure=#{var}/lib/dbus/machine-id"
  end

  test do
    system "#{bin}/dbus-daemon", "--version"
  end
end
