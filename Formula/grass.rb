class Grass < Formula
  desc "Geographic Resources Analysis Support System"
  homepage "https://grass.osgeo.org/"

  stable do
    url "https://grass.osgeo.org/grass64/source/grass-6.4.5.tar.gz"
    sha256 "f501da62807eb08efcb85820859fe5ade9bc392e20641b606273c956bb678f3e"

    # Patches to keep files from being installed outside of the prefix.
    # Also, quick patch for compiling with clang (as yet, unreported issue)
    patch :DATA
  end

  bottle do
    sha256 "9881162ad659b3e04e687933477fd10cf8726c53aa19fbfba9dfb3f685edaa25" => :el_capitan
    sha256 "aa4db69f55a2fd3b5a09cebcc4706009743ba5d7e46ee46ad958f274799e33f6" => :yosemite
    sha256 "42304f890bd466dfbbe4dcccde86ecd85c209ea38e908320f94d2a745233ef59" => :mavericks
  end

  head do
    url "https://svn.osgeo.org/grass/grass/trunk"

    patch do
      url "https://gist.githubusercontent.com/jctull/0fe3db92a3e7c19fa6e0/raw/42e819f0a9b144de782c94f730dbc4da136e9227/grassPatchHead.diff"
      sha256 "a30caef931b70f37700823d028bce38af978ccb472649ec17920d91197421bc5"
    end
  end

  option "without-gui", "Build without WxPython interface. Command line tools still available."

  depends_on :macos => :lion
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "readline"
  depends_on "gdal"
  depends_on "libtiff"
  depends_on "unixodbc"
  depends_on "fftw"
  depends_on "cairo"
  depends_on :x11 # needs to find at least X11/include/GL/gl.h
  depends_on "wxpython" if build.with? "gui"
  depends_on :postgresql => :optional
  depends_on :mysql => :optional

  def headless?
    # The GRASS GUI is based on WxPython.
    build.without? "gui"
  end

  def install
    readline = Formula["readline"].opt_prefix
    gettext = Formula["gettext"].opt_prefix

    args = [
      "--disable-debug", "--disable-dependency-tracking",
      "--enable-largefile",
      "--enable-shared",
      "--with-cxx",
      "--without-motif",
      "--with-python",
      "--with-blas",
      "--with-lapack",
      "--with-sqlite",
      "--with-odbc",
      "--with-geos=#{Formula["geos"].opt_bin}/geos-config",
      "--with-proj-share=#{Formula["proj"].opt_share}/proj",
      "--with-png",
      "--with-readline-includes=#{readline}/include",
      "--with-readline-libs=#{readline}/lib",
      "--with-readline",
      "--with-nls-includes=#{gettext}/include",
      "--with-nls-libs=#{gettext}/lib",
      "--with-nls",
      "--with-freetype",
      "--without-tcltk", # Disabled due to compatibility issues with OS X Tcl/Tk
      "--with-includes=#{gettext}/include"
    ]

    unless MacOS::CLT.installed?
      # On Xcode-only systems (without the CLT), we have to help:
      args << "--with-macosx-sdk=#{MacOS.sdk_path}"
      args << "--with-opengl-includes=#{MacOS.sdk_path}/System/Library/Frameworks/OpenGL.framework/Headers"
    end

    if headless?
      args << "--without-wxwidgets"
    else
      python_site_packages = HOMEBREW_PREFIX/"lib/python2.7/site-packages"
      default_wx_path = File.read(python_site_packages/"wx.pth").strip
      ENV.prepend_path "PYTHONPATH", python_site_packages/default_wx_path
      args << "--with-wxwidgets=#{Formula["wxmac"].opt_bin}/wx-config"
    end

    args << "--enable-64bit" if MacOS.prefer_64_bit?
    args << "--with-macos-archs=#{MacOS.preferred_arch}"

    cairo = Formula["cairo"]
    args << "--with-cairo-includes=#{cairo.include}/cairo"
    args << "--with-cairo-libs=#{cairo.lib}"
    args << "--with-cairo"

    # Database support
    args << "--with-postgres" if build.with? "postgresql"

    if build.with? "mysql"
      mysql = Formula["mysql"]
      args << "--with-mysql-includes=#{mysql.include}/mysql"
      args << "--with-mysql-libs=#{mysql.lib}"
      args << "--with-mysql"
    end

    if MacOS.version >= :el_capitan
      # handle stripping of DYLD_* env vars by SIP when passed to utilities;
      # HOME env var is .brew_home during build, so it is still checked for lib
      ln_sf "#{buildpath}/dist.x86_64-apple-darwin#{`uname -r`.strip}/lib", ".brew_home/lib"
    end

    system "./configure", "--prefix=#{prefix}", *args
    # make and make install must be separate steps.
    system "make", "GDAL_DYNAMIC="
    # GDAL_DYNAMIC set to blank for r.external compatability
    system "make", "GDAL_DYNAMIC=", "install"
  end

  def caveats
    if headless?
      <<-EOS.undent
        This build of GRASS has been compiled without the WxPython GUI.

        The command line tools remain fully functional.
        EOS
    end
  end

  test do
    system "#{bin}/grass64", "--version"
  end
end


__END__
Remove two lines of the Makefile that try to install stuff to
/Library/Documentation---which is outside of the prefix and usually fails due
to permissions issues.

diff --git a/Makefile b/Makefile
index f1edea6..be404b0 100644
--- a/Makefile
+++ b/Makefile
@@ -304,8 +304,6 @@ ifeq ($(strip $(MINGW)),)
 	-tar cBf - gem/skeleton | (cd ${INST_DIR}/etc ; tar xBf - ) 2>/dev/null
 	-${INSTALL} gem/gem$(GRASS_VERSION_MAJOR)$(GRASS_VERSION_MINOR) ${BINDIR} 2>/dev/null
 endif
-	@# enable OSX Help Viewer
-	@if [ "`cat include/Make/Platform.make | grep -i '^ARCH.*darwin'`" ] ; then /bin/ln -sfh "${INST_DIR}/docs/html" /Library/Documentation/Help/GRASS-${GRASS_VERSION_MAJOR}.${GRASS_VERSION_MINOR} ; fi


 install-strip: FORCE
diff --git a/raster/r.terraflow/direction.cc b/raster/r.terraflow/direction.cc
index 7744518..778c225 100644
--- a/raster/r.terraflow/direction.cc
+++ b/raster/r.terraflow/direction.cc
@@ -53,11 +53,11 @@ encodeDirectionMFD(const genericWindow<elevation_type>& elevwin,
   
   if(!is_nodata(elevwin.get())) {
     dir = 0;
-    if (elevwin.get(5) < elevwin.get() && !is_void(elevwin.get(5))) dir |= 1;
-    if (elevwin.get(3) < elevwin.get() && !is_void(elevwin.get(3))) dir |= 16;
+    if (elevwin.get(5) < elevwin.get() && !is_voided(elevwin.get(5))) dir |= 1;
+    if (elevwin.get(3) < elevwin.get() && !is_voided(elevwin.get(3))) dir |= 16;
     for(int i=0; i<3; i++) {
-      if(elevwin.get(i) < elevwin.get() && !is_void(elevwin.get(i))) dir |= 32<<i;
-      if(elevwin.get(i+6) < elevwin.get() && !is_void(elevwin.get(6+i))) dir |= 8>>i;
+      if(elevwin.get(i) < elevwin.get() && !is_voided(elevwin.get(i))) dir |= 32<<i;
+      if(elevwin.get(i+6) < elevwin.get() && !is_voided(elevwin.get(6+i))) dir |= 8>>i;
     }
   }
   
diff --git a/raster/r.terraflow/nodata.cc b/raster/r.terraflow/nodata.cc
index 159c66d..610ca55 100644
--- a/raster/r.terraflow/nodata.cc
+++ b/raster/r.terraflow/nodata.cc
@@ -73,7 +73,7 @@ is_nodata(float x) {
 
 
 int
-is_void(elevation_type el) {
+is_voided(elevation_type el) {
   return (el == nodataType::ELEVATION_NODATA);
 }
 
diff --git a/raster/r.terraflow/nodata.h b/raster/r.terraflow/nodata.h
index 1e843c5..ac56504 100644
--- a/raster/r.terraflow/nodata.h
+++ b/raster/r.terraflow/nodata.h
@@ -37,7 +37,7 @@
 int is_nodata(elevation_type el);
 int is_nodata(int x);
 int is_nodata(float x);
-int is_void(elevation_type el);
+int is_voided(elevation_type el);
 
 
 class nodataType : public ijBaseType {
