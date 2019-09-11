class Cutter < Formula
  desc "Unit Testing Framework for C and C++"
  homepage "https://cutter.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cutter/cutter/1.2.6/cutter-1.2.6.tar.gz"
  sha256 "459becce78ec4c568f4f5a5e20c73ea36be283bf955f4a252e8491b634339065"
  revision 1
  head "https://github.com/clear-code/cutter.git"

  bottle do
    sha256 "2c69a7d83b9776729939f829fc7b025eb44a012e41643cd9a7a8cbde9d274d09" => :mojave
    sha256 "560d2c76c2603bb947095653e6f13db90cf9fe2b09f44cafdf063244fe4c4ec4" => :high_sierra
    sha256 "3226b680ed29260aa73024751635b45cf9bb9baa4f7e5e50b379591e837a0b8a" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-goffice",
                          "--disable-gstreamer",
                          "--disable-libsoup"
    system "make"
    system "make", "install"
  end

  test do
    touch "1.txt"
    touch "2.txt"
    system bin/"cut-diff", "1.txt", "2.txt"
  end
end
