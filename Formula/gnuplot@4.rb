class GnuplotAT4 < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/4.6.7/gnuplot-4.6.7.tar.gz"
  sha256 "26d4d17a00e9dcf77a4e64a28a3b2922645b8bbfe114c0afd2b701ac91235980"

  bottle do
    sha256 "ae5b2efeadf424eb90aab81f3ec9c1fa043e8fe20047939f45f40b6bdf2f82be" => :sierra
    sha256 "3d736c253a44e5811494f1d89b9563b79d5d258517df474a11c648b8de37ba59" => :el_capitan
    sha256 "932530bf585e2ea0b2d8408b344bfb454c756e3bfb177dbb7c4d1d6b2ce15ad5" => :yosemite
  end

  keg_only :versioned_formula

  option "with-pdflib-lite", "Build the PDF terminal using pdflib-lite"
  option "with-wxmac", "Build the wxWidgets terminal using pango"
  option "with-cairo", "Build the Cairo based terminals"
  option "without-lua", "Build without the lua/TikZ terminal"
  option "with-test", "Verify the build with make check (1 min)"
  option "without-emacs", "Do not build Emacs lisp files"
  option "with-aquaterm", "Build with AquaTerm support"
  option "with-x11", "Build with X11 support"

  depends_on "pkg-config" => :build
  depends_on "lua" => :recommended
  depends_on "gd" => :recommended
  depends_on "readline"
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "fontconfig"
  depends_on "pango" if (build.with? "cairo") || (build.with? "wxmac")
  depends_on "pdflib-lite" => :optional
  depends_on "wxmac" => :optional
  depends_on :x11 => :optional

  def install
    if build.with? "aquaterm"
      # Add "/Library/Frameworks" to the default framework search path, so that an
      # installed AquaTerm framework can be found. Brew does not add this path
      # when building against an SDK (Nov 2013).
      ENV.prepend "CPPFLAGS", "-F/Library/Frameworks"
      ENV.prepend "LDFLAGS", "-F/Library/Frameworks"
    else
      inreplace "configure", "-laquaterm", ""
    end

    # Help configure find libraries
    readline = Formula["readline"].opt_prefix
    pdflib = Formula["pdflib-lite"].opt_prefix
    gd = Formula["gd"].opt_prefix

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-readline=#{readline}
      --without-latex
    ]

    args << "--with-pdf=#{pdflib}" if build.with? "pdflib-lite"
    args << (build.with?("gd") ? "--with-gd=#{gd}" : "--without-gd")

    if build.without? "wxmac"
      args << "--disable-wxwidgets"
      args << "--without-cairo" if build.without? "cairo"
    end

    args << "--without-lua" if build.without? "lua"
    args << (build.with?("emacs") ? "--with-lispdir=#{elisp}" : "--without-lisp-files")
    args << (build.with?("aquaterm") ? "--with-aquaterm" : "--without-aquaterm")
    args << (build.with?("x11") ? "--with-x" : "--without-x")

    # From latest gnuplot formula on core:
    # > The tutorial requires the deprecated subfigure TeX package installed
    # > or it halts in the middle of the build for user-interactive resolution.
    # > Per upstream: "--with-tutorial is horribly out of date."
    args << "--without-tutorial"

    system "./configure", *args
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    system "make", "check" if build.with? "test"
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
        set terminal png;
        set output "#{testpath}/image.png";
        plot sin(x);
    EOS
    assert (testpath/"image.png").exist?
  end
end
