class GupnpAv < Formula
  desc "Library to help implement UPnP A/V profiles"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-av/0.14/gupnp-av-0.14.1.tar.xz"
  sha256 "b79ce0cc4b0c66d9c54bc22183a10e5709a0011d2af272025948efcab33a3e4f"

  bottle do
    sha256 arm64_ventura:  "33af0c7369b538b76818cbbb1df0fc5bd698036cd1a6e30d7c12d307defa0540"
    sha256 arm64_monterey: "2bf2c5d017d82c6e5564d9568440e2eddfc93263adee2e764aff9665267048ec"
    sha256 arm64_big_sur:  "ca281e73715c56efb4f8903c5cba976180890796136177b6907bd83651ef1ba0"
    sha256 ventura:        "10f84e50d875ab9aeda5ef4a744db153cc20488f8d0fa459c286c620b16cc367"
    sha256 monterey:       "9d57d74084ca05914aedb3b3c7315b29a0cf1161cb6f90371a6d438bd4630d76"
    sha256 big_sur:        "5535428dcd1ec5bc06921b6d8abec7e94351aebcb3d513382720aacd06360f21"
    sha256 catalina:       "0ce8655955b14c12a6de4abceb47f383c7bfa1b3ee385adfb07f20e2c1c43b82"
    sha256 x86_64_linux:   "30a19a226bb9463538b5bb3f6ecdaf68a6280e6678cd18bafb00cf607601ac36"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end
end
