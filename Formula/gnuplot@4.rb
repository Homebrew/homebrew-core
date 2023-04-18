class GnuplotAT4 < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/4.6.7/gnuplot-4.6.7.tar.gz"
  sha256 "26d4d17a00e9dcf77a4e64a28a3b2922645b8bbfe114c0afd2b701ac91235980"
  license "gnuplot"
  revision 4

  bottle do
    sha256 arm64_ventura:  "60736d0dfebcac12418bdfeeffe252ff7acb811a760fb80fe90919f5f33f0307"
    sha256 arm64_monterey: "efa6e1ee1c2c04c013bfe3f5ff0647c0141e6e319115a083f0a6f6d83924a790"
    sha256 arm64_big_sur:  "d888310976f77989dee4e9be57ed338ac7c17921878f17bed9c36bf38dfa82e7"
    sha256 ventura:        "f160dbb2c64620f126c0a78b5167ccf0f2ae935bec503db70c8f0a4df6f78e05"
    sha256 monterey:       "eb8e43f689561ce88af9dc218bb082225e639c7940310d5615184dc9550e9dd0"
    sha256 big_sur:        "9c6bcfd67e5eecdce98190cb3ef40a4a2af3807d7d64dff0374f487fd38cb9ab"
    sha256 catalina:       "50fca4d825a24a009c45d5f677000340ef638deb11fe1f9701208595f829af08"
  end

  keg_only :versioned_formula

  deprecate! date: "2022-02-28", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "gd"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "lua@5.1"
  depends_on "readline"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["lua@5.1"].opt_libexec/"lib/pkgconfig"

    # Do not build with Aquaterm
    inreplace "configure", "-laquaterm", ""

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-wxwidgets
      --with-aquaterm
      --with-gd=#{Formula["gd"].opt_prefix}
      --with-lispdir=#{elisp}
      --with-readline=#{Formula["readline"].opt_prefix}
      --without-cairo
      --without-latex
      --without-pdf
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
