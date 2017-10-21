class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.2.0/gnuplot-5.2.0.tar.gz"
  sha256 "7dfe6425a1a6b9349b1fb42dae46b2e52833b13e807a78a613024d6a99541e43"

  bottle do
    sha256 "bfd640f5695bacc875b063b4a2290b319d0da85372c4d1c10ffba4794a2d2210" => :high_sierra
    sha256 "8c43e0b7e86325aee11a7bd6d49fbc7ca18480d592b806061a45a6a5d9c30545" => :sierra
    sha256 "d070515c0ef22f4a74f93854ba4ad62c142d2c2d1e0088d9186356853e32ebf5" => :el_capitan
    sha256 "cbc87c7746aeb65acf5231d3114672bf003c1a4583b12be229de586310a83ab1" => :yosemite
  end

  head do
    url ":pserver:anonymous:@gnuplot.cvs.sourceforge.net:/cvsroot/gnuplot", :using => :cvs

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-cairo", "Build the Cairo based terminals"
  option "without-lua", "Build without the lua/TikZ terminal"
  option "with-wxmac", "Build wxmac support. Need with-cairo to build wxt terminal"
  option "with-aquaterm", "Build with AquaTerm support"

  deprecated_option "with-x" => "with-x11"
  deprecated_option "wx" => "with-wxmac"
  deprecated_option "qt" => "with-qt"
  deprecated_option "with-qt5" => "with-qt"
  deprecated_option "cairo" => "with-cairo"
  deprecated_option "nolua" => "without-lua"

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "readline"
  depends_on "lua" => :recommended
  depends_on "pango" if build.with?("cairo") || build.with?("wxmac")
  depends_on "qt" => :optional
  depends_on "wxmac" => :optional
  depends_on :x11 => :optional

  needs :cxx11 if build.with? "qt"

  resource "libcerf" do
    url "http://apps.jcns.fz-juelich.de/src/libcerf/libcerf-1.5.tgz"
    mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/libcerf/libcerf-1.5.tgz"
    sha256 "e36dc147e7fff81143074a21550c259b5aac1b99fc314fc0ae33294231ca5c86"
  end

  def install
    # Qt5 requires c++11 (and the other backends do not care)
    ENV.cxx11 if build.with? "qt"

    if build.with? "aquaterm"
      # Add "/Library/Frameworks" to the default framework search path, so that an
      # installed AquaTerm framework can be found. Brew does not add this path
      # when building against an SDK (Nov 2013).
      ENV.prepend "CPPFLAGS", "-F/Library/Frameworks"
      ENV.prepend "LDFLAGS", "-F/Library/Frameworks"
    end

    # Build libcerf
    resource("libcerf").stage do
      system "./configure", "--prefix=#{buildpath}/libcerf", "--enable-static", "--disable-shared"
      system "make", "install"
    end
    ENV.prepend_path "PKG_CONFIG_PATH", buildpath/"libcerf/lib/pkgconfig"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
      --without-tutorial
    ]

    if build.without? "wxmac"
      args << "--disable-wxwidgets"
      args << "--without-cairo" if build.without? "cairo"
    end

    if build.with? "qt"
      args << "--with-qt"
    else
      args << "--with-qt=no"
    end

    args << "--without-lua" if build.without? "lua"
    args << (build.with?("aquaterm") ? "--with-aquaterm" : "--without-aquaterm")
    args << (build.with?("x11") ? "--with-x" : "--without-x")

    system "./prepare" if build.head?
    system "./configure", *args
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    system "make", "install"
  end

  def caveats
    if build.with? "aquaterm"
      <<~EOS
        AquaTerm support will only be built into Gnuplot if the standard AquaTerm
        package from SourceForge has already been installed onto your system.
        If you subsequently remove AquaTerm, you will need to uninstall and then
        reinstall Gnuplot.
      EOS
    end
  end

  test do
    system "#{bin}/gnuplot", "-e", <<~EOS
      set terminal dumb;
      set output "#{testpath}/graph.txt";
      plot sin(x);
    EOS
    assert_predicate testpath/"graph.txt", :exist?
  end
end
