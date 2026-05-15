class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/46/ngspice-46.tar.gz"
  sha256 "a0d1699af1940b06649276dcd6ff5a566c8c0cad01b2f7b5e99dedbb4d64c19b"
  license :cannot_represent
  revision 1
  head "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "8343461583c56ca951d0508e8459462ea98f6af3f1783e2e491874828a1a5ad9"
    sha256 arm64_sequoia: "3cffddf9fe4c94c3b706847ba461d60ca89dff9379839d72cc1c2f75e060983d"
    sha256 arm64_sonoma:  "3ce129ec06cd1db6ead129a5f36a645fa196920df68b2b3870d4e3f8a840c7ee"
    sha256 sonoma:        "93543c940da1f0d3d9f413ea0e49e1e7b274ea57d8bfde30ef8d6e1386b4782c"
    sha256 arm64_linux:   "8f25521726c656b9866cb1ebb30bdd3c23ce6da724536a4de01b0597ccc7f3b1"
    sha256 x86_64_linux:  "f42643fd6446de764738e5a58b68a01136f8ae8c6e89f8bbadae66b8db0bb1e7"
  end

  depends_on "fftw"
  depends_on "freetype"
  depends_on "libngspice"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxt"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  on_macos do
    depends_on "libice"
    depends_on "libsm"
    depends_on "libxext"
    depends_on "libxmu"
  end

  # Disable the broken macOS memory check. upstream commit ref, https://sourceforge.net/p/ngspice/ngspice/ci/96404e993984065f9104d724672bcdcafd7f356f/
  patch :DATA

  def install
    # Xft #includes <ft2build.h>, not <freetype2/ft2build.h>, hence freetype2
    # must be put into the search path.
    ENV.append "CFLAGS", "-I#{Formula["freetype"].opt_include}/freetype2"

    args = %w[
      --enable-cider
      --enable-xspice
      --disable-openmp
      --enable-pss
      --with-readline=yes
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # fix references to libs
    inreplace pkgshare/"scripts/spinit", lib/"ngspice/", Formula["libngspice"].opt_lib/"ngspice/"

    # remove conflict lib files with libngspice
    rm_r(Dir[lib/"ngspice"])
  end

  def caveats
    <<~EOS
      If you need the graphical plotting functions you need to install X11 with:
        brew install --cask xquartz
    EOS
  end

  test do
    (testpath/"test.cir").write <<~EOS
      RC test circuit
      v1 1 0 1
      r1 1 2 1
      c1 2 0 1 ic=0
      .tran 100u 100m uic
      .control
      run
      quit
      .endc
      .end
    EOS
    system bin/"ngspice", "test.cir"
  end
end

__END__
diff --git a/src/frontend/outitf.c b/src/frontend/outitf.c
index a9e47df..56883b0 100644
--- a/src/frontend/outitf.c
+++ b/src/frontend/outitf.c
@@ -556,6 +556,7 @@ OUTpD_memory(runDesc *run, IFvalue *refValue, IFvalue *valuePtr)
 {
     int i, n = run->numData;
 
+#ifndef __APPLE__
     if (!cp_getvar("no_mem_check", CP_BOOL, NULL, 0)) {
         /* Estimate the required memory */
         size_t memrequ = (size_t)n * vlength2delta(0) * sizeof(double);
@@ -569,6 +570,7 @@ OUTpD_memory(runDesc *run, IFvalue *refValue, IFvalue *valuePtr)
             controlled_exit(1);
         }
     }
+#endif
 
     for (i = 0; i < n; i++) {
