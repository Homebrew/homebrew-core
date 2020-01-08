class Pcb < Formula
  desc "Interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-4.2.1/pcb-4.2.1.tar.gz"
  sha256 "981532c0a1efd09e3ab6aa690992a4338d0970736ad709c51397bf0d24db3fc5"
  version_scheme 1

  bottle do
    sha256 "20254cf55d1b28f5485c4b9865f536a77df6e4c993c7e9392c2408b2352ec6fd" => :catalina
    sha256 "b8307f5227c9479cf344e927c12ba075f47eea359c4b81f06108f0441301bbe3" => :mojave
    sha256 "b9da3459cad08ada02a9bd4ec840cecca099ba96c07c0f462b749671eaac9eb6" => :high_sierra
  end

  head do
    url "git://git.geda-project.org/pcb.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "dbus"
  depends_on "gd"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "gtkglext"

  conflicts_with "gts", :because => "both install a `gts.h` header"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-update-desktop-database",
                          "--disable-update-mime-database",
                          "--disable-gl",
                          "--without-x"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pcb --version")
  end
end
