class DbusGlib < Formula
  desc "GLib bindings for the D-Bus message bus system"
  homepage "https://wiki.freedesktop.org/www/Software/DBusBindings/"
  url "https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.110.tar.gz"
  sha256 "7ce4760cf66c69148f6bd6c92feaabb8812dee30846b24cd0f7395c436d7e825"

  bottle do
    cellar :any
    sha256 "4e7193ebfc16eeb9635ae90023890df2735bcf8b28851ed8d284969548a3d4bd" => :high_sierra
    sha256 "9eae92ddc86a2b845e3de72e75c8cf5f965e170c921b30dc6540e4126ee89ed8" => :sierra
    sha256 "122823a60de6d94f947fd7a0db6f28ceb7c751b55e72a48d14917d021ed033ae" => :el_capitan
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
