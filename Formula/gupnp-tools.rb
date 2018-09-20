class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.8/gupnp-tools-0.8.14.tar.xz"
  sha256 "682b952b3cf43818c7d27549c152ea52e43320500820ab3392cf5a29a95e7efa"
  revision 1

  bottle do
    sha256 "4e56b83a3164e3ffa9adae38accc5099ae421727dde982f38dbbc912566b5e90" => :mojave
    sha256 "45ebb44e94ed47a5e47e6eb7de6fa4abc68029ca96a9f5217dfb3176c95c343f" => :high_sierra
    sha256 "270aa92cd6ae9fd83560c997d444afff984615c71bf81600701c22fe0216c058" => :sierra
    sha256 "dd76de959f08a89e5cba3c135607af53a922413f584397cd141fb6a93b52587c" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "gtksourceview3"
  depends_on "gupnp"
  depends_on "gupnp-av"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/gupnp-universal-cp", "-h"
    system "#{bin}/gupnp-av-cp", "-h"
  end
end
