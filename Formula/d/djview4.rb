class Djview4 < Formula
  desc "Viewer for the DjVu image format"
  homepage "https://djvu.sourceforge.net/djview4.html"
  url "https://downloads.sourceforge.net/project/djvu/DjView/4.12/djview-4.12.tar.gz"
  sha256 "5673c6a8b7e195b91a1720b24091915b8145de34879db1158bc936b100eaf3e3"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/djview[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "50f358049ae7371431b1640620050d40f9075e998695efc69e3cfc228955d189"
    sha256 cellar: :any,                 arm64_sonoma:   "aeec9249493e568780d0760a7c11d597c51e9a89835d9d7be3a3512510dd6e09"
    sha256 cellar: :any,                 arm64_ventura:  "a852adaa4bb85ae49414a271aa1b183595b523d994d338567a18384097ce1abf"
    sha256 cellar: :any,                 arm64_monterey: "7386959e5881c110ca398bd1ec94f962a4d726ea659ef26c804cbf68aaf4fceb"
    sha256 cellar: :any,                 arm64_big_sur:  "2da284a44e3e0a0a1a5dc29c7b6c71ef3e014d13d81846c9d7e88293b005081f"
    sha256 cellar: :any,                 sonoma:         "fb06597b392db6503ee92b70ee0074a0880b58e2d5fed3999d3b2c40b0039d28"
    sha256 cellar: :any,                 ventura:        "7c8e2da786b4d91a1d4af0991a7d8e49903c80101377a10f8b6920559e25aff1"
    sha256 cellar: :any,                 monterey:       "d5c2c116e402498ec6ffd6261ee5eeaec4374a6d9ec7b37c7cb4f5ff7f316b81"
    sha256 cellar: :any,                 big_sur:        "8f03e13feeb1f0e19b8a1f1b5638990557aaad04916e06826bee7511a0dbfbf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ad7de2463c9ef2720b7bd1a854ac73ed84bdf0ecb6273146a9a404a48b78eca"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "djvulibre"
  depends_on "libtiff"
  depends_on "qt@5"

  # Fix QT detection when multiple Xcode installations are present.
  # Submitted upstream: https://sourceforge.net/p/djvu/patches/44/
  patch :DATA

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--with-x=no",
                          "--disable-nsdejavu",
                          "--disable-desktopfiles",
                          "--with-tiff=#{Formula["libtiff"].opt_prefix}",
                          *std_configure_args
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
    assert_path_exists prefix/name
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
