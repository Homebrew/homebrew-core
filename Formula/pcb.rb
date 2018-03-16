class Pcb < Formula
  desc "Interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-4.1.0/pcb-4.1.0.tar.gz"
  sha256 "03dbee38e05f35fd289fb7d099f30e3ff139be76847d9359d78ed9ce1236e3b5"
  version_scheme 1

  bottle do
    sha256 "710be341aba45178726414555eff0f89eeaa78eb46f7e2c5ad271b21abfb182d" => :high_sierra
    sha256 "3858e75073db55a7bc5b27a1822cd68f97c1c6794088da7f78da14fd23fe3603" => :sierra
    sha256 "af63769b6696d51b6753e7af79069296a7cf07518cb053a0ed7b55467ae8f635" => :el_capitan
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
