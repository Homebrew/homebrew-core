class Pcb < Formula
  desc "Interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-4.3.0/pcb-4.3.0.tar.gz"
  sha256 "ae852f46af84aba7f51d813fb916fc7fcdbeea43f7134f150507024e1743fb5e"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    regex(%r{url=.*?/pcb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "41a14f1d1a3439469248dd6b58535c082f084376a90ecf3ccca2513e70cd2028"
    sha256 big_sur:       "f73590271ddcf104d25fecad90c916e4d535a5041280a1bbd661acdafc806b24"
    sha256 catalina:      "a8937f1ce318a6472532eae067dc581ddef61518a5b56db83883cb2119c2bf32"
    sha256 mojave:        "0607471efce526eb3fd06286f28fa664276ab8b4c3f407b14e18eb3c426cad59"
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

  conflicts_with "gts", because: "both install a `gts.h` header"

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
