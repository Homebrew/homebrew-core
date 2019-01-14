class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.2.6/gnuplot-5.2.6.tar.gz"
  sha256 "35dd8f013139e31b3028fac280ee12d4b1346d9bb5c501586d1b5a04ae7a94ee"
  revision 1

  bottle do
    sha256 "cb12fb041098c279de4935df173d133897d8ddf570d54e97dfd63b63e0e66875" => :mojave
    sha256 "63792153e87a8ecddf624ce0a636cc7f74c305099d30a9ba16ba964e047c7d8d" => :high_sierra
    sha256 "f0349b50e29572991c77aef9be3516c554cdf24bf653c496188a1a774913fb8e" => :sierra
  end

  head do
    url "https://git.code.sf.net/p/gnuplot/gnuplot-main.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-aquaterm", "Build with AquaTerm support"
  option "with-wxmac", "Build with wxmac support"

  deprecated_option "qt" => "with-qt"
  deprecated_option "with-qt5" => "with-qt"
  deprecated_option "with-x" => "with-x11"
  deprecated_option "wx" => "with-wxmac"

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libcerf"
  depends_on "lua"
  depends_on "pango"
  depends_on "readline"
  depends_on "qt" => :optional
  depends_on "wxmac" => :optional
  depends_on :x11 => :optional

  needs :cxx11 if build.with? "qt"

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

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
      --without-tutorial
    ]

    args << "--disable-wxwidgets" if build.without? "wxmac"
    args << (build.with?("aquaterm") ? "--with-aquaterm" : "--without-aquaterm")
    args << (build.with?("qt") ? "--with-qt" : "--with-qt=no")
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
