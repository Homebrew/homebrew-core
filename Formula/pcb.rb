class Pcb < Formula
  desc "Interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-4.2.0/pcb-4.2.0.tar.gz"
  sha256 "cd4b36df6747789775812fb433f246d6bd5a27f3a16357d78d9c4c9b59c59a43"
  version_scheme 1

  bottle do
    sha256 "66b44a80973cd1f37103815609ecc74dfcd111d86ad751828316ce5cb412a5bd" => :mojave
    sha256 "6be0b1c294817563732f0b698f09aac1ba035a8cd3cb19e89604f652d81776a0" => :high_sierra
    sha256 "327c985e641d0485f5b0fe9a02cfde8019db27c89235356265654bdc7f210cc3" => :sierra
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
