class Libvhdi < Formula
  desc "Library and tools to access the Virtual Hard Disk (VHD) image format"
  homepage "https://github.com/libyal/libvhdi"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libv/libvhdi/libvhdi_20170223.orig.tar.gz"
  version "20170223"
  sha256 "5a9fedaab51a14a92320cd672a48a0fa0b014b975d5dcea5d4e944b32bf1498d"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :osxfuse => :optional

  def install
    if build.head?
      system "./synclibs.sh"
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vhdiinfo -V")
  end
end
