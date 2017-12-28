class Gsound < Formula
  desc "Small library for playing system sounds"
  homepage "https://wiki.gnome.org/Projects/GSound"
  url "https://download.gnome.org/sources/gsound/1.0/gsound-1.0.2.tar.xz"
  sha256 "bba8ff30eea815037e53bee727bbd5f0b6a2e74d452a7711b819a7c444e78e53"

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libcanberra"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-static
      --disable-gtk-doc
    ]

    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    ["python", "python3"].each do |python|
      system python, "-c", "from gi.repository import GSound"
    end
  end
end
