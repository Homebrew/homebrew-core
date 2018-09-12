class Pcb < Formula
  desc "Interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-4.1.2/pcb-4.1.2.tar.gz"
  sha256 "c6b4df11930d2b3d27032475850e15dd95797fb43876caa6e77c288724fdf05b"
  version_scheme 1

  bottle do
    sha256 "b5f5c3c8c057a50c49b0ba426ad1edcd7e1bee8d7183dd85d0e3098ffcf3685c" => :mojave
    sha256 "8885f48b85c579d192e8492ef3f48a84460af797e90f40d26d3fbda26962be23" => :high_sierra
    sha256 "e4dc058b053ba4ce4203770063712007420592bbe3f552c1ea949f055f4f3a61" => :sierra
    sha256 "381e6760f94254e92d95be3abe734e94db490fe2c443e9be1f25cb3c6ae08686" => :el_capitan
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
