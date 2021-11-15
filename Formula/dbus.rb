class Dbus < Formula
  # releases: even (1.12.x) = stable, odd (1.13.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.12.20.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/d/dbus/dbus_1.12.20.orig.tar.gz"
  sha256 "f77620140ecb4cdc67f37fb444f8a6bea70b5b6461f12f1cbe2cec60fa7de5fe"
  license any_of: ["AFL-2.1", "GPL-2.0-or-later"]

  livecheck do
    url "https://dbus.freedesktop.org/releases/dbus/"
    regex(/href=.*?dbus[._-]v?(\d+\.\d*?[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "0e2aad84a0961daecdb9a3c588b6038ff88d500b549c02fdc38c7c785b4c8a76"
    sha256 arm64_big_sur:  "98319ca7d3dda690a932243a20a1ebaebe89e2386282bad7232f842f2abecbc5"
    sha256 monterey:       "71e9a67e7580064db9b92c433188975181854b873a905bff16d79fd261a46d4b"
    sha256 big_sur:        "e3ff464367ad79df35c0f81d70a58607a174e9fa63cd507b575f0988ec913b7d"
    sha256 catalina:       "23513ea5d75203fe4374ab37cc4226f23f34ec604449ef572fd6a2b48a612ff3"
    sha256 mojave:         "912da7c3211a981762dc45e4f67fbedd1afd379459a40244340c83caa4134382"
    sha256 high_sierra:    "6c98efff3cb8fdbba552351a2953f85953f053e12a8af891461118d37affdb73"
    sha256 x86_64_linux:   "21857954e349d0ff49abec1ed39f574cb7c2dce10587a085030c30a8cf98cabc"
  end

  head do
    url "https://gitlab.freedesktop.org/dbus/dbus.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build

  uses_from_macos "expat"

  on_macos do
    # Patch applies the config templating fixed in https://bugs.freedesktop.org/show_bug.cgi?id=94494
    # Homebrew pr/issue: 50219
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/0a8a55872e/d-bus/org.freedesktop.dbus-session.plist.osx.diff"
      sha256 "a8aa6fe3f2d8f873ad3f683013491f5362d551bf5d4c3b469f1efbc5459a20dc"
    end
  end

  def install
    # Fix the TMPDIR to one D-Bus doesn't reject due to odd symbols
    ENV["TMPDIR"] = "/tmp"
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./autogen.sh", "--no-configure" if build.head?

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--localstatedir=#{var}",
      "--sysconfdir=#{etc}",
      "--enable-xml-docs",
      "--disable-doxygen-docs",
      "--without-x",
      "--disable-tests",
    ]

    if OS.mac?
      args << "--enable-launchd"
      args << "--with-launchd-agent-dir=#{prefix}"
    end

    system "./configure", *args
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
