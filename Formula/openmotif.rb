class Openmotif < Formula
  desc "LGPL release of the Motif toolkit"
  homepage "https://motif.ics.com/motif"
  url "https://downloads.sourceforge.net/project/motif/Motif%202.3.8%20Source%20Code/motif-2.3.8.tar.gz"
  sha256 "859b723666eeac7df018209d66045c9853b50b4218cecadb794e2359619ebce7"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    sha256 arm64_ventura:  "d89a76242fafca764691044cab4fc7e5b3bf0eaa1756b07732e6645ff3642c75"
    sha256 arm64_monterey: "3942656be5f95807753f8549c98d5263cc9bd510a9b73e4bb6256dfa8928bd76"
    sha256 arm64_big_sur:  "004bb6002de4b145d78adfb0dfd3dc69de01012daa7632770329bf658cb52420"
    sha256 ventura:        "be57abbebbed852db219a8b1052cb6dc19bc816a9bfa39c02d4f5fe563fa9be5"
    sha256 monterey:       "3d8e123bd66804492e9c029dd8cf4f5c6eee742f55558e8aeda6cc80f41021cc"
    sha256 big_sur:        "186bd2c9a8f7d69e31e4d00e206036f8128483627e1af8310b847d2e327bb413"
    sha256 catalina:       "3cc1aea00676992dc09e499f10737729e964cab6fb8750d0d54c51a3716d1166"
    sha256 x86_64_linux:   "a7ec8d4e5739b6c130dadce451e3d2ee44658e87958a93e67548afe2b36e6b62"
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libice"
  depends_on "libpng"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxmu"
  depends_on "libxp"
  depends_on "libxt"
  depends_on "xbitmaps"

  uses_from_macos "flex" => :build

  conflicts_with "lesstif",
    because: "both Lesstif and Openmotif are complete replacements for each other"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    if OS.linux?
      # This patch is needed for Ubuntu 16.04 LTS, which uses
      # --as-needed with ld.  It should no longer
      # be needed on Ubuntu 18.04 LTS.
      inreplace ["demos/programs/Exm/simple_app/Makefile.am", "demos/programs/Exm/simple_app/Makefile.in"],
        /(LDADD.*\n.*libExm.a)/,
        "\\1 -lX11"
    end

    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"

    # Avoid conflict with Perl
    mv man3/"Core.3", man3/"openmotif-Core.3"
  end

  test do
    assert_match "no source file specified", pipe_output("#{bin}/uil 2>&1")
  end
end
