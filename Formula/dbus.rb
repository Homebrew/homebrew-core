class Dbus < Formula
  # releases: even (1.12.x) = stable, odd (1.13.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.14.4.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/d/dbus/dbus_1.14.4.orig.tar.xz"
  sha256 "7c0f9b8e5ec0ff2479383e62c0084a3a29af99edf1514e9f659b81b30d4e353e"
  license any_of: ["AFL-2.1", "GPL-2.0-or-later"]

  livecheck do
    url "https://dbus.freedesktop.org/releases/dbus/"
    regex(/href=.*?dbus[._-]v?(\d+\.\d*?[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "bd47d7e498d2c564cc9e1a72171c188a579baa2b0b1ae7fdbc90403f0b40ff56"
    sha256 arm64_monterey: "a7c5e9ebfa5e456cfbb3e78ee917898e89cb4672b8fd0aa5bec679723d8685f5"
    sha256 arm64_big_sur:  "77c1c3aa6d4e2d86d5c0e505326297bb4873d9cfb475eb0faad0ae588384d8af"
    sha256 ventura:        "44e1e11140160c1aba37a011693779ebf5313735f9febce5a60958099ab76506"
    sha256 monterey:       "0ac396a8e236fb1324f0008017e2e2dc096eec1e804e80082096974df86038f2"
    sha256 big_sur:        "1e5f498229eb4607bad387c03b7fa29b28e5cd3d5189fbd506abfdc7e8e5bdb2"
    sha256 catalina:       "ddc436c75350923f396fc2296b7c2e432190a1d7efec209db34b0b50fc523a9b"
    sha256 x86_64_linux:   "d7bdfb3e9401543b28b9db7fc137ed1129f5cdd23335fbe544ed438edfba3354"
  end

  head do
    url "https://gitlab.freedesktop.org/dbus/dbus.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build

  uses_from_macos "expat"

  # Patch applies the config templating fixed in https://bugs.freedesktop.org/show_bug.cgi?id=94494
  # Homebrew pr/issue: 50219
  patch do
    on_macos do
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
