class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/archive/ARAVIS_0_6_1.tar.gz"
  sha256 "d9795d36bfb1af230bda21d93bc81390f49d936c6c9b7b3043a5c09bd0f0f8d3"

  bottle do
    sha256 "a8faa1da38cca132fa068c207fc36e41ec61ea9618c86ae503f6d18b9e8abfec" => :mojave
    sha256 "814c7f8168575e730a3e299fb272050c9522773b12d5a5bbeeba31cfb5dd9b27" => :high_sierra
    sha256 "553fe6f0343f4b4088c5634f270adb7436372f224d65a17b67b6bb4918a11f1c" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gtk-doc" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "intltool"
  depends_on "libnotify"
  depends_on "libusb"

  def install
    inreplace "viewer/Makefile.am", "gtk-update-icon-cache", "gtk3-update-icon-cache"
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.0.6.so")
    assert_match /Description *Aravis Video Source/, output
  end
end
