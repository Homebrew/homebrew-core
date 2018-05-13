class Pcb < Formula
  desc "Interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-4.1.2/pcb-4.1.2.tar.gz"
  sha256 "c6b4df11930d2b3d27032475850e15dd95797fb43876caa6e77c288724fdf05b"
  version_scheme 1

  bottle do
    sha256 "7e229670841427c9fbf4b673c63e07c21e8acc23ad88d0d260525c8476c59364" => :high_sierra
    sha256 "fc93a4a84a76fb056244da2225136e668a19ca03db91ade3ac8ca1110bf61686" => :sierra
    sha256 "565a73d1f78acf7fd32ede476fc63028a8eb2d98a330d991a09e2b20bd923d31" => :el_capitan
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
