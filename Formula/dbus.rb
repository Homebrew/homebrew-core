class Dbus < Formula
  # releases: even (1.10.x) = stable, odd (1.11.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.10.12.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dbus/dbus_1.10.12.orig.tar.gz"
  sha256 "210a79430b276eafc6406c71705e9140d25b9956d18068df98a70156dc0e475d"

  bottle do
    rebuild 1
    sha256 "fd7a6f18cc6770a055ecc383281e9cf3e3c06fb1339e7008a87bfc38a0add3c8" => :sierra
    sha256 "297e18121ad14e4d04021eb8ef79c116ed0118b03ddd877d706916c31868bec3" => :el_capitan
    sha256 "33477927d3a16d8a00d4e985028bf7536d0aebf983c25eee401ee223e0efb484" => :yosemite
  end

  devel do
    url "https://dbus.freedesktop.org/releases/dbus/dbus-1.11.6.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dbus/dbus_1.11.6.orig.tar.gz"
    sha256 "a228ce822983206becd5d36c0a63243ea77d47f65134feccacb10350250b9c0e"
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
