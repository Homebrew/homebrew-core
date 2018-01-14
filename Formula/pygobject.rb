class Pygobject < Formula
  desc "GLib/GObject/GIO Python bindings for Python 2"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/2.28/pygobject-2.28.7.tar.xz"
  sha256 "bb9d25a3442ca7511385a7c01b057492095c263784ef31231ffe589d83a96a5a"
  revision 1

  bottle do
    cellar :any
    sha256 "44d2fbe065a06b2f874b8d0b770375b0e8628a77f67823a09cf354d4bf1fd3e3" => :high_sierra
    sha256 "85854484b61200e295a9767b34bb86eb06b33045429f160c19f84cca39abaf17" => :sierra
    sha256 "47b48d492fad94254508ce966c3e9261b74879049a5fc9a4fb34e3209c0f4ce5" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "python"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-introspection"
    system "make", "install"
    (lib/"python2.7/site-packages/pygtk.pth").append_lines <<~EOS
      #{HOMEBREW_PREFIX}/lib/python2.7/site-packages/gtk-2.0
    EOS
  end

  test do
    system "python", "-c", "import dsextras"
  end
end
