class Dbus < Formula
  # releases: even (1.10.x) = stable, odd (1.11.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.12.10.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dbus/dbus_1.12.10.orig.tar.gz"
  sha256 "4b693d24976258c3f2fa9cc33ad9288c5fbfa7a16481dbd9a8a429f7aa8cdcf7"

  bottle do
    sha256 "6eaf963c1f7bc2604c5fe8c800cdd52721cfb21200267c1c56e701a05426eac2" => :high_sierra
    sha256 "d12854df2e48b8bb588f83ec8cff31bd00fed71b244a2598f4d3dd5637ed4944" => :sierra
    sha256 "82511d36589b8d90e3a96e552911dace38c4876cbb52f9057ee997667cd034ff" => :el_capitan
  end

  devel do
    url "https://dbus.freedesktop.org/releases/dbus/dbus-1.13.6.tar.gz"
    sha256 "b533693232d36d608a09f70c15440c1816319bac3055433300d88019166c1ae4"
  end

  head do
    url "https://anongit.freedesktop.org/git/dbus/dbus.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "xmlto" => :build

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

  def post_install
    # Generate D-Bus's UUID for this machine
    system "#{bin}/dbus-uuidgen", "--ensure=#{var}/lib/dbus/machine-id"
  end

  test do
    system "#{bin}/dbus-daemon", "--version"
  end
end
