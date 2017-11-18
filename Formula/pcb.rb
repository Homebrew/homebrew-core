class Pcb < Formula
  desc "Interactive printed circuit board editor"
  homepage "http://pcb.geda-project.org/"
  url "https://downloads.sourceforge.net/project/pcb/pcb/pcb-4.0.2/pcb-4.0.2.tar.gz"
  sha256 "3f0a934612c82078dea269f7adcdc5d953377be3cd910cbc6d51b9722e8df9a8"
  version_scheme 1

  bottle do
    sha256 "ec94bcde5dd1536e1fe0c5aa9de8e185471b5d06a8c18325ac70e9666dbd9a9b" => :high_sierra
    sha256 "2662ca0773a1a10c2e1e203c9186ddb066659b94d854e079e45853aaf3e21aea" => :sierra
    sha256 "7662578205878b0c46db601619a5370db18f1c9abbb5111e28c5c52e2aa21c44" => :el_capitan
    sha256 "b5c1c8ce425cfc22d328254e03bf40b463521577f055c182f3807f5bcf9db033" => :yosemite
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
