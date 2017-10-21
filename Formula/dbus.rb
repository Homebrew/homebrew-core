class Dbus < Formula
  # releases: even (1.10.x) = stable, odd (1.11.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.10.24.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dbus/dbus_1.10.24.orig.tar.gz"
  sha256 "71184eb27638e224579ffa998e88f01d0f1fef17a7811406e53350735eaecd1b"

  bottle do
    sha256 "94aa4146fefeb941bcb7b8d65d7109dea8b35ba2eac306b6b6815b274e8716ac" => :high_sierra
    sha256 "aa7bee810c612aa0640961473691aff286dfff84d99c8f090722ed44d6940061" => :sierra
    sha256 "0b6302f7811cdd47df1b897db2e673d83519e8f5e5543e7ce0eca6f1934e73ec" => :el_capitan
  end

  devel do
    url "https://dbus.freedesktop.org/releases/dbus/dbus-1.11.18.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dbus/dbus_1.11.18.orig.tar.gz"
    sha256 "fa2b5ac7acbe9a6d67a5d308d167e2ce9a5176a9aade81ec42754312a74a8457"

    depends_on "coreutils" => :build
    depends_on "pkg-config" => :build
    depends_on "expat"
  end

  head do
    url "https://anongit.freedesktop.org/git/dbus/dbus.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "coreutils" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
    depends_on "expat"
  end

  depends_on "xmlto" => :build

  # Patch applies the config templating fixed in https://bugs.freedesktop.org/show_bug.cgi?id=94494
  # Homebrew pr/issue: 50219
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0a8a55872e/d-bus/org.freedesktop.dbus-session.plist.osx.diff"
    sha256 "a8aa6fe3f2d8f873ad3f683013491f5362d551bf5d4c3b469f1efbc5459a20dc"
  end

  def install
    unless build.stable?
      ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"
    end

    # Fix the TMPDIR to one D-Bus doesn't reject due to odd symbols
    ENV["TMPDIR"] = "/tmp"

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
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  def post_install
    # Generate D-Bus's UUID for this machine
    system "#{bin}/dbus-uuidgen", "--ensure=#{var}/lib/dbus/machine-id"
  end

  test do
    system "#{bin}/dbus-daemon", "--version"
  end
end
