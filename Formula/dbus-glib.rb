class DbusGlib < Formula
  desc "GLib bindings for the D-Bus message bus system"
  homepage "https://wiki.freedesktop.org/www/Software/DBusBindings/"
  url "https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.110.tar.gz"
  sha256 "7ce4760cf66c69148f6bd6c92feaabb8812dee30846b24cd0f7395c436d7e825"

  bottle do
    cellar :any
    sha256 "3557c1341a5e5ba8edd314a0d0fd6b5b88577ce8228363fc341d872e68aa6a32" => :high_sierra
    sha256 "75b313131b5b37dbb8899901239183b1bdce3dcad0a42fae82c0681b7ae233c9" => :sierra
    sha256 "397f602c5f4a7dcb69c12c1c33be603f4c6640244ff70732f06fa6d86a8654a3" => :el_capitan
    sha256 "815d7200c61d67960fb60ba4bc42a10f8c822b2ab58d63fb967122cd14444d9c" => :yosemite
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
