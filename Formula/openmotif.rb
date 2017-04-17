class Openmotif < Formula
  desc "LGPL release of the Motif toolkit"
  homepage "https://motif.ics.com/motif"
  url "https://downloads.sourceforge.net/project/motif/Motif%202.3.7%20Source%20Code/motif-2.3.7.tar.gz"
  sha256 "8f7aadbb0f42df2093d4690735a2b9a02ea2bf69dfb15ae0a39cae28f1580d14"

  bottle do
    sha256 "efdbcaaf32496ce3a728c75c2349e28ca8a4b53463b24f3907d55ede3a7a5988" => :sierra
    sha256 "73b9b20a5b215fa6f60facf5f431e29fd86110103f533adf6e340b4090c8ff7c" => :el_capitan
    sha256 "3184a926a49f650bf07e100454401a777233986ea2c69eb1fef0e2e7922ebcab" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg" => :optional
  depends_on "libpng" => :optional
  depends_on :x11

  conflicts_with "lesstif",
    :because => "Lesstif and Openmotif are complete replacements for each other"

  # Removes a flag clang doesn't recognise/accept as valid
  # From https://trac.macports.org/browser/trunk/dports/x11/openmotif/files/patch-configure.ac.diff
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b10858b/openmotif/patch-configure.ac.diff"
    sha256 "0cfff42cb7f37d4bd14fe778ba3d85e418586636b185b0c90e9e3c7d0a35feef"
  end

  # "Only weak aliases are supported on darwin"
  # Adapted from https://trac.macports.org/browser/trunk/dports/x11/openmotif/files/patch-lib-XmP.h.diff
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b10858b/openmotif/patch-lib-XmP.h.diff"
    sha256 "320754bd0c1fa520c7576f3c7a22249a9b741c12f29606652add4a7a62c75d3f"
  end

  # Fix VendorShell reference for XQuartz 2.7.9+
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b10858b/openmotif/patch-lib-VendorS.c.diff"
    sha256 "71b0573aea2d53cc304f206e2d68e5fa7922782cc21cc404b72739b01bfc8034"
  end

  def install
    # https://trac.macports.org/browser/trunk/dports/x11/openmotif/Portfile#L59
    # Compile breaks if these three files are present.
    %w[demos/lib/Exm/String.h demos/lib/Exm/StringP.h demos/lib/Exm/String.c].each do |f|
      rm_rf f
    end

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    args << "--disable-jpeg" if build.without? "jpeg"
    args << "--disable-png" if build.without? "libpng"

    system "./configure", *args
    system "make"
    system "make", "install"

    # Avoid conflict with Perl
    mv man3/"Core.3", man3/"openmotif-Core.3"
  end

  test do
    assert_match /no source file specified/, pipe_output("#{bin}/uil 2>&1")
  end
end
