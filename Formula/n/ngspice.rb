class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/47/ngspice-47.tar.gz"
  sha256 "894e649651f1838a14095e5a5439e7d3aa63e87ede14d283173fda4fcdef675f"
  license :cannot_represent
  head "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "0da9798c61ce91057391c0e954ac1bcfbf1104ce037a07cae8f76e00fdbe4798"
    sha256 arm64_sequoia: "d929329a10079a6291b36549b1ace8a0dfb2956d7569135e7dad1795239e2959"
    sha256 arm64_sonoma:  "30cdfc20c90c7fa794a865edb4d0d8d1008e5763b6212d9abedcb9b4b600b065"
    sha256 sonoma:        "1d3026868f4e7209112668f4de3cdc38b78bab717ecabf8befd7fd4d9c185d01"
    sha256 arm64_linux:   "cf2463e038ebbe2215edc013c906dd24b1fc1c15c01afe7fea220a67c249efd4"
    sha256 x86_64_linux:  "319a6cbbffdf71453d8593bc713c335d1690d5db6fc03d6b40326425001ff91c"
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
    ENV.append "CFLAGS", "-I#{formula_opt_include("freetype")}/freetype2"

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
    inreplace pkgshare/"scripts/spinit", lib/"ngspice/", formula_opt_lib("libngspice")/"ngspice/"

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
    (testpath/"test.cir").write <<~CIR
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
    CIR
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
