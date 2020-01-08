class GnuplotAT4 < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/4.6.7/gnuplot-4.6.7.tar.gz"
  sha256 "26d4d17a00e9dcf77a4e64a28a3b2922645b8bbfe114c0afd2b701ac91235980"
  revision 3

  bottle do
    sha256 "aca6da067597cd60e147c1534d0f6cf86f874de847a62888fda313ad66ea5d79" => :catalina
    sha256 "e1444a4c413bb9e5d6670c3b8216761f097dd1ba6943f075f3014391184bd2d5" => :mojave
    sha256 "63368d69e33d92bd7f36e5ebd4f5245263c656171ff2e9d346183d0e3ea45534" => :high_sierra
    sha256 "d6439eb67f9da39adfacfbeef4719efa6a88ebeb6a4f8091b5e1dac267479d3b" => :sierra
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "gd"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "lua@5.1"
  depends_on "pdflib-lite"
  depends_on "readline"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["lua@5.1"].opt_libexec/"lib/pkgconfig"

    # Do not build with Aquaterm
    inreplace "configure", "-laquaterm", ""

    pdflib = Formula["pdflib-lite"].opt_prefix
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-wxwidgets
      --with-aquaterm
      --with-gd=#{Formula["gd"].opt_prefix}
      --with-lispdir=#{elisp}
      --with-pdf=#{pdflib}
      --with-readline=#{Formula["readline"].opt_prefix}
      --without-cairo
      --without-latex
      --without-tutorial
      --without-x
    ]

    system "./configure", *args
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    system "make", "install"
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
