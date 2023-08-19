class Dbus < Formula
  # releases: even (1.12.x) = stable, odd (1.13.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.14.8.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/d/dbus/dbus_1.14.8.orig.tar.xz"
  sha256 "a6bd5bac5cf19f0c3c594bdae2565a095696980a683a0ef37cb6212e093bde35"
  license any_of: ["AFL-2.1", "GPL-2.0-or-later"]

  livecheck do
    url "https://dbus.freedesktop.org/releases/dbus/"
    regex(/href=.*?dbus[._-]v?(\d+\.\d*?[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2fd1191077516a815c1f3279f0eb827a6fe0ad4bfd9c560fa6e3b73fd532756e"
    sha256 arm64_monterey: "73673573372117ad20ba011c2decd5f29e03cc4354e8857d8c3ee112a1e54adc"
    sha256 arm64_big_sur:  "ae1b0422e7e732ab4ca5a5184dbf643758a02c28f571a55b11334d49a3bb35f4"
    sha256 ventura:        "eda570ab373b38077ca171a3089e14ff7f43864a554ccb829f71b3e61c470d46"
    sha256 monterey:       "b14a272413fb4c4c04c4980d0f848de4dba62d2aee2033cc1e3c2f6ca861f337"
    sha256 big_sur:        "a1b3cc09397f94d69bd9fc425628ee15b01079c927ce2e480e6a6a13b2fe617b"
    sha256 x86_64_linux:   "e317deee5c58aea9757d6a84537a5b54532e593a366901005786b9f4d00fb00f"
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

  def post_install
    # Generate D-Bus's UUID for this machine
    system "#{bin}/dbus-uuidgen", "--ensure=#{var}/lib/dbus/machine-id"
  end

  service do
    name macos: "org.freedesktop.dbus-session"
  end

  test do
    system "#{bin}/dbus-daemon", "--version"
  end
end
