class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.0.6/gnuplot-5.0.6.tar.gz"
  sha256 "5bbe4713e555c2e103b7d4ffd45fca69551fff09cf5c3f9cb17428aaacc9b460"

  bottle do
    sha256 "396cd2d3c9efaec862ee85584265d581e95a7e9baacd86a49b63a373282168a4" => :sierra
    sha256 "eab3867b1f875653987cdfe0c02236a7c6e5cdf70f5d2bf1f89c67782f8672bd" => :el_capitan
    sha256 "fe94c99facb225000db381a47d934daa243c48815195123db10d14628e92335c" => :yosemite
  end

  head do
    url ":pserver:anonymous:@gnuplot.cvs.sourceforge.net:/cvsroot/gnuplot", :using => :cvs

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-cairo", "Build the Cairo based terminals"
  option "without-lua", "Build without the lua/TikZ terminal"
  option "with-test", "Verify the build with make check"
  option "with-wxmac", "Build wxmac support. Need with-cairo to build wxt terminal"
  option "with-aquaterm", "Build with AquaTerm support"
  option "without-gd", "Build without gd based terminals"
  option "with-libcerf", "Build with libcerf support"

  deprecated_option "with-x" => "with-x11"
  deprecated_option "pdf" => "with-pdflib-lite"
  deprecated_option "wx" => "with-wxmac"
  deprecated_option "qt" => "with-qt@5.7"
  deprecated_option "with-qt" => "with-qt@5.7"
  deprecated_option "with-qt5" => "with-qt@5.7"
  deprecated_option "cairo" => "with-cairo"
  deprecated_option "nolua" => "without-lua"
  deprecated_option "tests" => "with-test"
  deprecated_option "with-tests" => "with-test"

  depends_on "pkg-config" => :build
  depends_on "gd" => :recommended
  depends_on "lua" => :recommended
  depends_on "readline"
  depends_on "pango" if build.with?("cairo") || build.with?("wxmac")
  depends_on "pdflib-lite" => :optional
  depends_on "qt@5.7" => :optional
  depends_on "wxmac" => :optional
  depends_on :x11 => :optional

  needs :cxx11 if build.with? "qt@5.7"

  resource "libcerf" do
    url "http://apps.jcns.fz-juelich.de/src/libcerf/libcerf-1.5.tgz"
    mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/libcerf/libcerf-1.5.tgz"
    sha256 "e36dc147e7fff81143074a21550c259b5aac1b99fc314fc0ae33294231ca5c86"
  end

  def install
    # Qt5 requires c++11 (and the other backends do not care)
    ENV.cxx11 if build.with? "qt@5.7"

    if build.with? "aquaterm"
      # Add "/Library/Frameworks" to the default framework search path, so that an
      # installed AquaTerm framework can be found. Brew does not add this path
      # when building against an SDK (Nov 2013).
      ENV.prepend "CPPFLAGS", "-F/Library/Frameworks"
      ENV.prepend "LDFLAGS", "-F/Library/Frameworks"
    end

    if build.with? "libcerf"
      # Build libcerf
      resource("libcerf").stage do
        system "./configure", "--prefix=#{buildpath}/libcerf", "--enable-static", "--disable-shared"
        system "make", "install"
      end
      ENV.prepend "PKG_CONFIG_PATH", buildpath/"libcerf/lib/pkgconfig"
    end

    # Help configure find libraries
    pdflib = Formula["pdflib-lite"].opt_prefix

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
      --without-latex
    ]

    args << "--without-libcerf" if build.without? "libcerf"

    args << "--with-pdf=#{pdflib}" if build.with? "pdflib-lite"

    args << "--without-gd" if build.without? "gd"

    if build.without? "wxmac"
      args << "--disable-wxwidgets"
      args << "--without-cairo" if build.without? "cairo"
    end

    if build.with? "qt@5.7"
      args << "--with-qt"
    else
      args << "--with-qt=no"
    end

    # The tutorial requires the deprecated subfigure TeX package installed
    # or it halts in the middle of the build for user-interactive resolution.
    # Per upstream: "--with-tutorial is horribly out of date."
    args << "--without-tutorial"
    args << "--without-lua" if build.without? "lua"
    args << ((build.with? "aquaterm") ? "--with-aquaterm" : "--without-aquaterm")
    args << ((build.with? "x11") ? "--with-x" : "--without-x")

    system "./prepare" if build.head?
    system "./configure", *args
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    system "make", "check" if build.with?("test") || build.bottle?
    system "make", "install"
  end

  def caveats
    if build.with? "aquaterm"
      <<-EOS.undent
        AquaTerm support will only be built into Gnuplot if the standard AquaTerm
        package from SourceForge has already been installed onto your system.
        If you subsequently remove AquaTerm, you will need to uninstall and then
        reinstall Gnuplot.
      EOS
    end
  end

  test do
    system "#{bin}/gnuplot", "-e", <<-EOS.undent
      set terminal dumb;
      set output "#{testpath}/graph.txt";
      plot sin(x);
    EOS
    File.exist? testpath/"graph.txt"
  end
end
