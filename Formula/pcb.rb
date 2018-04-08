class Pcb < Formula
  desc "Interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-4.1.1/pcb-4.1.1.tar.gz"
  sha256 "1f921bb110cc28238788b64a85bc6ea50cc4de8856fe285a1e571ac2728480bd"
  version_scheme 1

  bottle do
    sha256 "42442f547e7bca5ff5195310d38ee266e60ae6b8b7a4c38aaf24621e92e0c763" => :high_sierra
    sha256 "52868e929f78698f0817e53067bba02fb7add79f5fc45a8edaeeed163ab6c0e2" => :sierra
    sha256 "e9ebfa2b6c2751ef68eaa08f8890d63fe24206be04d3c0e40d688a7744ea3a22" => :el_capitan
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
