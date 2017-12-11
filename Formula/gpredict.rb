class Gpredict < Formula
  desc "Real-time satellite tracking/prediction application"
  homepage "http://gpredict.oz9aec.net/"
  url "https://downloads.sourceforge.net/project/gpredict/Gpredict/2.0/gpredict-2.0.tar.gz"
  sha256 "508f882383eac326aecb0b058378fc71f13b431c581e0efc28ee3c4216c76e16"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "goocanvas"
  depends_on "gtk+3"
  depends_on "hamlib"
  depends_on "adwaita-icon-theme"

  def install
    gettext = Formula["gettext"]
    ENV.append "CFLAGS", "-I#{gettext.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib}"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"gpredict", "-h"
  end
end
