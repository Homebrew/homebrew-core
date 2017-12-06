class GnuplotAT4 < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/4.6.7/gnuplot-4.6.7.tar.gz"
  sha256 "26d4d17a00e9dcf77a4e64a28a3b2922645b8bbfe114c0afd2b701ac91235980"
  revision 2

  bottle do
    sha256 "27435780b2fd1a5aa6cae54d829758af3e67f09814e393af2a4b99ba7680be4f" => :high_sierra
    sha256 "22c1e2e18e582e43a234b4e4d98c1a332093d95c20b5bfd05cd74317c9bafaad" => :sierra
    sha256 "bf1eda673d961f221a4183993e966e6ff93818a2edb566b18e0d80f2cf0daed3" => :el_capitan
  end

  keg_only :versioned_formula

  option "with-pdflib-lite", "Build the PDF terminal using pdflib-lite"
  option "with-wxmac", "Build the wxWidgets terminal using pango"
  option "with-cairo", "Build the Cairo based terminals"
  option "without-lua@5.1", "Build without the lua/TikZ terminal"
  option "with-test", "Verify the build with make check (1 min)"
  option "without-emacs", "Do not build Emacs lisp files"
  option "with-aquaterm", "Build with AquaTerm support"
  option "with-x11", "Build with X11 support"

  deprecated_option "without-lua" => "without-lua@5.1"

  depends_on "pkg-config" => :build
  depends_on "lua@5.1" => :recommended
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
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["lua@5.1"].opt_libexec/"lib/pkgconfig"

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

    args << "--without-lua" if build.without? "lua@5.1"
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
      set terminal png;
      set output "#{testpath}/image.png";
      plot sin(x);
    EOS
    assert_predicate testpath/"image.png", :exist?
  end
end
