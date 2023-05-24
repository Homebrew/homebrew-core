class Dbus < Formula
  # releases: even (1.12.x) = stable, odd (1.13.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.14.6.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/d/dbus/dbus_1.14.6.orig.tar.xz"
  sha256 "fd2bdf1bb89dc365a46531bff631536f22b0d1c6d5ce2c5c5e59b55265b3d66b"
  license any_of: ["AFL-2.1", "GPL-2.0-or-later"]

  livecheck do
    url "https://dbus.freedesktop.org/releases/dbus/"
    regex(/href=.*?dbus[._-]v?(\d+\.\d*?[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "ec0d9980cd5e80731bcf807a35719afb88b6178acbcd0c8ca04fc7bc430ca13b"
    sha256 arm64_monterey: "aaadcaa68cbb6cc782692ef476562302da02318c80395b1aaf8207a0dc5ccafa"
    sha256 arm64_big_sur:  "392325157689cb7e867e0eb1960207a1743bc8e07fafc53788abd85d6f3ca11c"
    sha256 ventura:        "3b543b7dd34df33bcd4d1bf169663e2a44e5d564ae44aa301887257ad05c6faf"
    sha256 monterey:       "33c126b61e16c4c26af8db9cf01e8e8e9a0f0b7d8abed530204f65192cfe1bbd"
    sha256 big_sur:        "d17fb587941944b04a8ed8f1974bf2848f977ae2edef69b9f3ea76bfa4842259"
    sha256 x86_64_linux:   "f63b8565981e3c11b67f8801daf0f56eec357bc7bafabd481e29042f9c3cae93"
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
