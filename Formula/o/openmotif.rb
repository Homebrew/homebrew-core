class Openmotif < Formula
  desc "LGPL release of the Motif toolkit"
  homepage "https://motif.ics.com/motif"
  url "https://downloads.sourceforge.net/project/motif/Motif%202.3.8%20Source%20Code/motif-2.3.8.tar.gz"
  sha256 "859b723666eeac7df018209d66045c9853b50b4218cecadb794e2359619ebce7"
  license "LGPL-2.1-or-later"
  revision 4
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "c0bfac872caadffd55339660bae1d6f2b3c7e5453524561f7c74a8ee19c649c1"
    sha256 arm64_sequoia: "891b9cebcba317b8a31d705ac752f285140823c8e49c2ef07723cb5c909f9c3e"
    sha256 arm64_sonoma:  "21605264e90be187d695971f25b00ab6913b7cbe9b8a9550ae5cbe656208b5dd"
    sha256 sonoma:        "ad3dd71f84bc42558d9d8d327fabf8a2c3e3f5bb04c9053f3422c816987b74eb"
    sha256 arm64_linux:   "81c0e83009c1e586a0f24db70915d074fed577be6c8e90d03eb76acc2b0b6e8f"
    sha256 x86_64_linux:  "0d5600cd872a9afd8a2af1d9dfd72ee38f227304f4b5849def52bbd697c4956d"
  end

  depends_on "pkgconf" => :build
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

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  # Fix 2-level namespace using MacPorts patch
  patch :p0 do
    on_macos do
      url "https://raw.githubusercontent.com/macports/macports-ports/8c436a9c53a7b786da8d42cda16eead0fb8733d4/x11/openmotif/files/patch-lib-xm-vendor.diff"
      sha256 "697ac026386dec59b82883fb4a9ba77164dd999fa3fb0569dbc8fbdca57fe200"
    end
  end

  # Fix performance of text anti-aliasing:
  # - https://github.com/justinmeiners/classic-colors/issues/12
  # - http://bugs.motifzone.com/show_bug.cgi?id=1715
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/b18bd78945e11e0b43be4445a52beaac3b37a274/Patches/openmotif/fix-anti-aliasing-performance.patch"
    sha256 "12907f303766cf1601714181c6276d0ebf94d36624eb2bbd8592ec046342ed77"
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

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"

    # Avoid conflict with Perl
    mv man3/"Core.3", man3/"openmotif-Core.3"
  end

  test do
    assert_match "no source file specified", pipe_output("#{bin}/uil 2>&1")
  end
end
