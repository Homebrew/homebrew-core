class Openmotif < Formula
  desc "LGPL release of the Motif toolkit"
  homepage "https://motif.ics.com/motif"
  url "https://downloads.sourceforge.net/project/motif/Motif%202.3.8%20Source%20Code/motif-2.3.8.tar.gz"
  sha256 "859b723666eeac7df018209d66045c9853b50b4218cecadb794e2359619ebce7"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "04764ff04cd2dd89cca22efe8e477f35ea48b5e1e82899a1cc741929c3269051"
    sha256 arm64_big_sur:  "ae3f4bf92f1cbc78a985e8c27979a52c1a4c16696a74bb142a317f88f5c46082"
    sha256 monterey:       "c648e27365e8df4bb9fc6bc1a518e02954a40108f9c08e7daf98c7c168bb9d0e"
    sha256 big_sur:        "ca698d287f8b964a34fa23cf2a8b6039fd5913d6169bbdf90bf90f6b580c8475"
    sha256 catalina:       "07edf35230c5dca07fd5b4aa3a198d9ec706319e9b57ae62259f63d9726262f7"
    sha256 mojave:         "b921f9634055bd7aaab722d156feca35da0742106036f23837241d53d1380648"
    sha256 high_sierra:    "0ebe3e7a88d400291a3e0a3f46d40b500c1e0487f5f689535c8c468993e786da"
    sha256 x86_64_linux:   "e833d9a0fd3a50c46a804214b71e8566cf89c3a9fcef026de1d82c1b7bf9f3ca"
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg"
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

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make"
    system "make", "install"

    # Avoid conflict with Perl
    mv man3/"Core.3", man3/"openmotif-Core.3"
  end

  test do
    assert_match "no source file specified", pipe_output("#{bin}/uil 2>&1")
  end
end
