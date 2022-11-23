class Djview4 < Formula
  desc "Viewer for the DjVu image format"
  homepage "https://djvu.sourceforge.io/djview4.html"
  url "https://downloads.sourceforge.net/project/djvu/DjView/4.12/djview-4.12.tar.gz"
  sha256 "5673c6a8b7e195b91a1720b24091915b8145de34879db1158bc936b100eaf3e3"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/djview[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "02249e97f7ed0e00cde146b75f4ba346c853cdc16974127b28f7f20ad03b7e21"
    sha256 cellar: :any,                 arm64_monterey: "2495aff481ce3d1dc1fd6df41669068388956fe89ecd6302a7ed75f4feccc8e8"
    sha256 cellar: :any,                 arm64_big_sur:  "d732c90fdab920090c28baf8951d50da4523fc619ce22643819afbf1037e21fb"
    sha256 cellar: :any,                 ventura:        "e8d0856490fdaa8fb093fc3182b49764c0b5b1ff81c9c3fd41426d6390d440d4"
    sha256 cellar: :any,                 monterey:       "7a692725678245bacf5a728ffb9acdfd87f2e362e3853b2952fc27ca6fe1fc59"
    sha256 cellar: :any,                 big_sur:        "4e9a79b7d43536f816768e9dd5d5452b5f3f270772a482f5321f7e43712a0a30"
    sha256 cellar: :any,                 catalina:       "d55757a01f3e6e843427f018559cd3e881c230096b16238b2a8f5bd82379f2a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7e3d358bd12b6fcdc444d19901fc4462cdd9be04378490ed865c9419cfe2392"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "djvulibre"
  depends_on "qt@5"

  # Fix QT detection when multiple Xcode installations are present.
  # Submitted upstream: https://sourceforge.net/p/djvu/patches/44/
  patch :DATA

  def install
    system "autoreconf", "-fiv"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-x=no",
                          "--disable-nsdejavu",
                          "--disable-desktopfiles",
                          "--with-tiff=#{Formula["libtiff"].opt_prefix}"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"

    # From the djview4.8 README:
    # NOTE: Do not use command "make install".
    # Simply copy the application bundle where you want it.
    if OS.mac?
      prefix.install "src/djview.app"
      bin.write_exec_script prefix/"djview.app/Contents/MacOS/djview"
    else
      prefix.install "src/djview"
    end
  end

  test do
    name = if OS.mac?
      "djview.app"
    else
      "djview"
    end
    assert_predicate prefix/name, :exist?
  end
end

__END__
diff --git a/config/acinclude.m4 b/config/acinclude.m4
index 3c78d41..8eb0575 100644
--- a/config/acinclude.m4
+++ b/config/acinclude.m4
@@ -314,7 +314,7 @@ message(QT_INSTALL_BINS="$$[QT_INSTALL_BINS]")
 changequote([, ])dnl
 EOF
   if ( cd conftest.d && $QMAKE > conftest.out 2>&1 ) ; then
-    sed -e 's/^.*: *//' < conftest.d/conftest.out > conftest.d/conftest.sh
+    grep "Project MESSAGE:" < conftest.d/conftest.out | sed -e 's/^.*: *//' > conftest.d/conftest.sh
     . conftest.d/conftest.sh
     rm -rf conftest.d
   else
