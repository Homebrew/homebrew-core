class Cdrdao < Formula
  desc "Record CDs in Disk-At-Once mode"
  homepage "https://cdrdao.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cdrdao/cdrdao-1.2.4.tar.bz2"
  sha256 "358d9cb83370ceaecdc60564cbf14c2ea2636eac60a966e2461c011ba09853b4"

  bottle do
    sha256 "f8894deccbd18e7d5362ace73618666d9a79b233cea5dc6af367ab9e257332e0" => :mojave
    sha256 "1efaa356872419da65763a5e28faf262b79f5a37e2eb83c06c22e9846bae188f" => :high_sierra
    sha256 "cd0c72a2c84f084e4f5fe28df185e9154409645138e55502ffb9c4075ae4dfea" => :sierra
    sha256 "d49e947354162d163937e801fd00468823b16d8462e179f6cfe20a84eb19ffb5" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "lame"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mad"

  # first patch fixes build problems under 10.6
  # see https://sourceforge.net/p/cdrdao/patches/23/
  patch do
    url "https://sourceforge.net/p/cdrdao/patches/_discuss/thread/205354b0/141e/attachment/cdrdao-mac.patch"
    sha256 "ee1702dfd9156ebb69f5d84dcab04197e11433dd823e80923fd497812041179e"
  end

  # second patch fixes device autodetection on macOS
  # see https://trac.macports.org/ticket/27819
  # upstream bug report:
  # https://sourceforge.net/p/cdrdao/bugs/175/
  patch :p0, :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end

__END__
--- dao/main.cc	2013-11-26 12:00:00.000000000 -0400
+++ dao/main.cc	2013-11-26 12:00:00.000000000 -0400
@@ -1242,7 +1242,7 @@
 const char* getDefaultDevice(DaoDeviceType req)
 {
     int i, len;
-    static char buf[128];
+    static char buf[1024];
 
     // This function should not be called if the command issues
     // doesn't actually require a device.
@@ -1270,7 +1270,7 @@
 	    if (req == NEED_CDRW_W && !rww)
 	      continue;
 
-	    strncpy(buf, sdata[i].dev.c_str(), 128);
+	    strncpy(buf, sdata[i].dev.c_str(), 1024);
 	    delete[] sdata;
 	    return buf;
 	}
