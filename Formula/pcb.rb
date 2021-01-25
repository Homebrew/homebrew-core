class Pcb < Formula
  desc "Interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-4.2.2/pcb-4.2.2.tar.gz"
  sha256 "1ceeaf1bdbe0508b9b140ca421eb600836579114c04dee939341c5d594f36e5d"
  license "GPL-2.0"
  revision 1
  version_scheme 1

  livecheck do
    url :stable
    regex(%r{url=.*?/pcb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "04cf9052dcb362c237c6f0b6d08a6c552379a3ee02313c342c2878bb59c87495" => :big_sur
    sha256 "2b9c6d5652265df79bbfabd9c44d536eda042ca96477d2f3a73dfb75e74c97eb" => :arm64_big_sur
    sha256 "5b2b7bf29ad42bcecc53dbb0cee9b4801f64205db7f6a89277f9ee6fed5db050" => :catalina
    sha256 "2312c4e25ecb5197ce93bf288b898efa5918b1f8084921ded604503c84ed2d33" => :mojave
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
