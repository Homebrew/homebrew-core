class Dbus < Formula
  # releases: even (1.12.x) = stable, odd (1.13.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.14.0.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/d/dbus/dbus_1.14.0.orig.tar.xz"
  sha256 "ccd7cce37596e0a19558fd6648d1272ab43f011d80c8635aea8fd0bad58aebd4"
  license any_of: ["AFL-2.1", "GPL-2.0-or-later"]

  livecheck do
    url "https://dbus.freedesktop.org/releases/dbus/"
    regex(/href=.*?dbus[._-]v?(\d+\.\d*?[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "c9fd5fca636d95d017c791c0b5b87ec99cd3ac3ef7d194c3bb05448a52e2933a"
    sha256 arm64_big_sur:  "26e8143ae21a90e27e9d3218c69fe7ac509379bf6adc75e0293234c366a89b35"
    sha256 monterey:       "25e7cbac037a07c9bef1f0cf8346c6c755fa46ce1b71471e46f64f396441f734"
    sha256 big_sur:        "76ec924fed127229906ab2e90b30ecf1a856f0f50e9ab6519cbcee1f1202632f"
    sha256 catalina:       "8b983bdc674dff5647af3ecab82e44abacbb460db8c60435e16ae351f22bfacb"
    sha256 x86_64_linux:   "ccf0fc79f59fa7c0ac014861c70d2df8b0c8f8c7f688d548d84b74ce998ecd38"
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
