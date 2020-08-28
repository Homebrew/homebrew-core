class Pcb < Formula
  desc "Interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-4.2.2/pcb-4.2.2.tar.gz"
  sha256 "1ceeaf1bdbe0508b9b140ca421eb600836579114c04dee939341c5d594f36e5d"
  license "GPL-2.0"
  version_scheme 1

  livecheck do
    url :stable
    regex(%r{url=.*?/pcb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "a1dca0926d6752943013906f21eb4f1d14156fcbb3dfc9906953df52ab7e7b51" => :catalina
    sha256 "0f598ed594a62cf96451a20635e186967957db8a536c20398285d26d88505772" => :mojave
    sha256 "95e752fd6939e81b4fe3a1b5e035a2240921e8ad9e507373735b5c81336978e1" => :high_sierra
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
