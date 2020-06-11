class Dbus < Formula
  # releases: even (1.12.x) = stable, odd (1.13.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.12.18.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/d/dbus/dbus_1.12.18.orig.tar.gz"
  sha256 "64cf4d70840230e5e9bc784d153880775ab3db19d656ead8a0cb9c0ab5a95306"

  bottle do
    sha256 "db3b485e8763fb2a9be8876eaf71f73101964c2a62950faafe46b53ddeb0e9a9" => :catalina
    sha256 "603c1f498659a45af2d0267c7e42926136cb0997d8462886b50f37cb3bc1ffcf" => :mojave
    sha256 "14db248f05b8f20db085cfd60f4ac9132403c9c16898b236a9c2f7b61017ae0a" => :high_sierra
  end

  head do
    url "https://anongit.freedesktop.org/git/dbus/dbus.git"

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
