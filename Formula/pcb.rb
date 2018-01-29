class Pcb < Formula
  desc "Interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-4.1.0/pcb-4.1.0.tar.gz"
  sha256 "03dbee38e05f35fd289fb7d099f30e3ff139be76847d9359d78ed9ce1236e3b5"
  version_scheme 1

  bottle do
    sha256 "52874efdeb2c50a31b58f4e0855c89766205a59f376e189ee1f7ec90728092cc" => :high_sierra
    sha256 "dfe4690fa564d2321b314a701f33e4611a8e5bf4454293e2d317278deead9733" => :sierra
    sha256 "c92046ddc82149c0bb382d7701055ce8e468731dee510da68aabe07b62fda962" => :el_capitan
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
