class Dbus < Formula
  # releases: even (1.10.x) = stable, odd (1.11.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.10.8.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dbus/dbus_1.10.8.orig.tar.gz"
  sha256 "baf3d22baa26d3bdd9edc587736cd5562196ce67996d65b82103bedbe1f0c014"
  head "https://anongit.freedesktop.org/git/dbus/dbus.git"

  bottle do
    sha256 "df858961c007d3f1bf7d2bc03856b4f1981b9c260837516da523e9d8162a3e46" => :el_capitan
    sha256 "e3bd3fc1b0a8eee96eda8dedbb4f610ac8c8a4b303f05c0f31be6bff55d573cd" => :yosemite
    sha256 "397cd888dcf08bd86c08e7c667663b896c65099c80ebe2901aa81050a9480541" => :mavericks
  end

  devel do
    url "https://dbus.freedesktop.org/releases/dbus/dbus-1.11.2.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dbus/dbus_1.11.2.orig.tar.gz"
    sha256 "5abc4c57686fa82669ad0039830788f9b03fdc4fff487f0ccf6c9d56ba2645c9"
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

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--disable-xml-docs",
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
