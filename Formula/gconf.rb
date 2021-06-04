class Gconf < Formula
  desc "System for storing user application preferences"
  homepage "https://projects.gnome.org/gconf/"
  url "https://download.gnome.org/sources/GConf/3.2/GConf-3.2.6.tar.xz"
  sha256 "1912b91803ab09a5eed34d364bf09fe3a2a9c96751fde03a4e0cfa51a04d784c"
  revision 1

  bottle do
    sha256 mojave:      "4c434b1dd944001776c5aae9924d0e3724a8682114924f8847aad30d990deccd"
    sha256 high_sierra: "e8a40df67c6816854cdfa9530e4c3b437907f5f92c32e8292f239d957dc1c0c8"
    sha256 sierra:      "46a60790c5f50f74833167d63e6a4772cd7b3de5672a54dd9a26ff7d82df1cb7"
    sha256 el_capitan:  "e810083f15d5ebb027c92071ea67c5960abf4d0b19c5e7809a71d026a78ae34a"
    sha256 yosemite:    "85f809fb483b3c78b283d3e7b681b133d106d991717d361c0bdd9596a81178ea"
  end

  disable! date: "2020-12-08", because: :unmaintained

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "dbus"
  depends_on "dbus-glib"
  depends_on "gettext"
  depends_on "glib"
  depends_on "orbit"

  uses_from_macos "libxml2"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-silent-rules", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"

    # Refresh the cache post-install, not during install.
    rm lib/"gio/modules/giomodule.cache"
  end

  def post_install
    system Formula["glib"].opt_bin/"gio-querymodules", HOMEBREW_PREFIX/"lib/gio/modules"
  end
end
