class Dbus < Formula
  # releases: even (1.12.x) = stable, odd (1.13.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.16.2.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/d/dbus/dbus_1.16.2.orig.tar.xz"
  sha256 "0ba2a1a4b16afe7bceb2c07e9ce99a8c2c3508e5dec290dbb643384bd6beb7e2"
  license any_of: ["AFL-2.1", "GPL-2.0-or-later"]
  head "https://gitlab.freedesktop.org/dbus/dbus.git", branch: "master"

  livecheck do
    url "https://dbus.freedesktop.org/releases/dbus/"
    regex(/href=.*?dbus[._-]v?(\d+\.\d*?[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "b03c304cbecc18a7fd132a24aac4ae0245a731b72ea7ce819353397cd0e05b2c"
    sha256 arm64_sonoma:  "540c1301f304a5da43ba2f1af7cff5ae6bbac3b28169f59d76741ec8105ea1ee"
    sha256 arm64_ventura: "55db2782d19df3356835e0f71b1edff1c9aad20084df237154760f7f73e21d0a"
    sha256 sonoma:        "cc14d4e58379b1c86bf51ce3ccb4a56ddf0808de29483cce83f5190c3dc0509b"
    sha256 ventura:       "a1e1ee9afdc8c822751f93d7513e08681546f851bc1df5a815841c881621605e"
    sha256 arm64_linux:   "b255e2237e533be133b8b637b8bc8425f754ba7a23bcdcf71a3634c5d4d79b4c"
    sha256 x86_64_linux:  "32d15b5c8ddfdbd62a0a232aed447ebc0311ab3812d6f08c6fde4af08dcb3af3"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "python" => :build
  uses_from_macos "expat"

  def install
    # Fix the TMPDIR to one D-Bus doesn't reject due to odd symbols
    ENV["TMPDIR"] = "/tmp"
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %W[
      -Dlocalstatedir=#{var}
      -Dsysconfdir=#{etc}
      -Dxml_docs=enabled
      -Ddoxygen_docs=disabled
      -Dmodular_tests=disabled
    ]

    args << "-Dlaunchd_agent_dir=#{lib}/Library/LaunchAgents" if OS.mac?

    # rpath is not set for meson build
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    # Generate D-Bus's UUID for this machine
    system bin/"dbus-uuidgen", "--ensure=#{var}/lib/dbus/machine-id"
  end

  def caveats
    on_macos do
      <<~EOS
        To load #{name} at startup, activate the included Launch Daemon:

          sudo cp #{lib}/Library/LaunchDaemons/org.freedesktop.dbus-session.plist /Library/LaunchDaemons
          sudo chmod 644 /Library/LaunchDaemons/org.freedesktop.dbus-session.plist
          sudo launchctl load -w /Library/LaunchDaemons/org.freedesktop.dbus-session.plist

        If this is an upgrade and you already have the Launch Daemon loaded, you
        have to unload the Launch Daemon before reinstalling it:

          sudo launchctl unload -w /Library/LaunchDaemons/org.freedesktop.dbus-session.plist
          sudo rm /Library/LaunchDaemons/org.freedesktop.dbus-session.plist
      EOS
    end
  end

  service do
    name macos: "org.freedesktop.dbus-session"
  end

  test do
    system bin/"dbus-daemon", "--version"
  end
end
