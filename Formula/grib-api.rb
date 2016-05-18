class GribApi < Formula
  desc "Encode and decode grib messages (editions 1 and 2)"
  homepage "https://software.ecmwf.int/wiki/display/GRIB/Home"
  url "https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.15.0-Source.tar.gz"
  sha256 "733f48e2882141003b83fa165d1ea12cad3c0c56953bc30be1d5d4aa6a0e5913"
  revision 1

  bottle do
    sha256 "73ba03c7dd6fb0374d9290844bba8ccc872fab0e9d6a863341b45c52da7993e9" => :el_capitan
    sha256 "34c8ff3bcca753743676e9a0c96f50edcc7ea72d24765b48b386bc743ff1bddb" => :yosemite
    sha256 "8f7350d08fc12db9f6f44174ac12a43666b02f168b1e58188a4fe40b31d68350" => :mavericks
  end

  option "with-static", "Build static instead of shared library."

  depends_on :fortran
  depends_on "cmake" => :build
  depends_on "jasper" => :recommended
  depends_on "openjpeg" => :optional
  depends_on "libpng" => :optional

  # Fixes build errors in Lion
  # https://software.ecmwf.int/wiki/plugins/viewsource/viewpagesrc.action?pageId=12648475
  patch :DATA

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DBUILD_SHARED_LIBS=OFF" if build.with? "static"
      args << "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}" << "-DENABLE_PNG=ON" if build.with? "libpng"
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    grib_samples_path = shell_output("#{bin}/grib_info -t").strip
    system "#{bin}/grib_ls", "#{grib_samples_path}/GRIB1.tmpl"
    system "#{bin}/grib_ls", "#{grib_samples_path}/GRIB2.tmpl"
  end
end

__END__
diff --git a/configure b/configure
index 0a88b28..9dafe46 100755
--- a/configure
+++ b/configure
@@ -7006,7 +7006,7 @@ $as_echo_n "checking for $compiler option to produce PIC... " >&6; }
     darwin* | rhapsody*)
       # PIC is the default on this platform
       # Common symbols not allowed in MH_DYLIB files
-      lt_prog_compiler_pic='-fno-common'
+      #lt_prog_compiler_pic='-fno-common'
       ;;
 
     hpux*)
@@ -12186,7 +12186,7 @@ $as_echo_n "checking for $compiler option to produce PIC... " >&6; }
     darwin* | rhapsody*)
       # PIC is the default on this platform
       # Common symbols not allowed in MH_DYLIB files
-      lt_prog_compiler_pic_F77='-fno-common'
+      #lt_prog_compiler_pic_F77='-fno-common'
       ;;
 
     hpux*)
@@ -15214,7 +15214,7 @@ $as_echo_n "checking for $compiler option to produce PIC... " >&6; }
     darwin* | rhapsody*)
       # PIC is the default on this platform
       # Common symbols not allowed in MH_DYLIB files
-      lt_prog_compiler_pic_FC='-fno-common'
+      #lt_prog_compiler_pic_FC='-fno-common'
       ;;
 
     hpux*)
