class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools."
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.8/gupnp-tools-0.8.13.tar.xz"
  sha256 "aa3decb9d532c0e2e505adc592f431fd81c0231ded2981129e87da13712479ed"

  bottle do
    sha256 "496e302a41c4781331b72cf19524e547498f5ab0867138e404dd0c0ebdadb649" => :sierra
    sha256 "d70fcdd9e3d84648678527c2edc84b2adcb31494f0ac544ba0258308017f2422" => :el_capitan
    sha256 "ee5c5f0a08432edae4b10310ac9771c94960ba80e14907cfdf64e14791426dac" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gupnp"
  depends_on "gupnp-av"
  depends_on "gtk+3"
  depends_on "gtksourceview3"
  depends_on "ossp-uuid"

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
