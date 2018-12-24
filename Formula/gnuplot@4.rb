class GnuplotAT4 < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/4.6.7/gnuplot-4.6.7.tar.gz"
  sha256 "26d4d17a00e9dcf77a4e64a28a3b2922645b8bbfe114c0afd2b701ac91235980"
  revision 2

  bottle do
    sha256 "3037a97469725cc72728cecbbdbf8c415258b58f67faac8cb9bc511750ebbfa4" => :mojave
    sha256 "27435780b2fd1a5aa6cae54d829758af3e67f09814e393af2a4b99ba7680be4f" => :high_sierra
    sha256 "22c1e2e18e582e43a234b4e4d98c1a332093d95c20b5bfd05cd74317c9bafaad" => :sierra
    sha256 "bf1eda673d961f221a4183993e966e6ff93818a2edb566b18e0d80f2cf0daed3" => :el_capitan
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
