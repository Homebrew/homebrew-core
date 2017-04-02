class DbusGlib < Formula
  desc "GLib bindings for the D-Bus message bus system"
  homepage "https://wiki.freedesktop.org/www/Software/DBusBindings/"
  url "https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.106.tar.gz"
  sha256 "b38952706dcf68bad9c302999ef0f420b8cf1a2428227123f0ac4764b689c046"
  revision 1

  bottle do
    cellar :any
    sha256 "5a13bf7a83e78eff703ec971e99866b1953c8984b8cb205e732c26c39499d4c2" => :sierra
    sha256 "f3ee7111b1633ff8bcff897b03e29bdcfbec6a7e05baf024f89f8a2bc95d2296" => :el_capitan
    sha256 "f5c3c7ce9505a8b95d9b4ed908858f9f013476f97f9461571f930e8341bd2bb2" => :yosemite
    sha256 "34e5041a6b4cfede31cfc252da290bdd0e8d133bb42e0526c0eac53830d12f28" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "dbus"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"dbus-binding-tool", "--help"
  end
end
