class DbusGlib < Formula
  desc "GLib bindings for the D-Bus message bus system"
  homepage "https://wiki.freedesktop.org/www/Software/DBusBindings/"
  url "https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.110.tar.gz"
  sha256 "7ce4760cf66c69148f6bd6c92feaabb8812dee30846b24cd0f7395c436d7e825"
  revision 1

  bottle do
    cellar :any
    sha256 "1e239ecd5e6ba952a9a31ea7902c6b67fe5cf25509a7c796987dfc97efdbd38d" => :catalina
    sha256 "107de2a15de30b069b1628b2b6aa347eaee4bc3931b9ba5a0b6ff9390e3550a8" => :mojave
    sha256 "c47b5a0470a8fa82ea95e53317aa255f413b158a0f63a6b5b2ecfd368f176ad4" => :high_sierra
    sha256 "bdf88ebc93b14b3f934f8ea8415234e099a20919bcf71b86c244393e31442f1c" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "dbus"
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"dbus-binding-tool", "--help"
  end
end
