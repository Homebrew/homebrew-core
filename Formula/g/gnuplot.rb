class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/6.0.3/gnuplot-6.0.3.tar.gz"
  sha256 "ec52e3af8c4083d4538152b3f13db47f6d29929a3f6ecec5365c834e77f251ab"
  license "gnuplot"

  livecheck do
    url :stable
    regex(%r{url=.*?/gnuplot[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:  "4f2052aecbd2f736e1b2318acce36c0cb233af6be0935deddcf998bd822b1013"
    sha256 arm64_ventura: "644cb48402329094a8de79741d5798c3720682f22c11330621d348e69bbb968b"
    sha256 sonoma:        "e347e5938f393d37b8d2f5e3b0bca7954d6829174af3c7768c13ac0c49874bf4"
    sha256 ventura:       "f8827be16a188c2388f7ad2ff9ccf5eda60152fc98a8fd64df6bbec7227c7011"
    sha256 x86_64_linux:  "ab0c9ee561bf5ad5c80c772b0210dc905319ac694e6867cef09dbce7d4c63508"
  end

  head do
    url "https://git.code.sf.net/p/gnuplot/gnuplot-main.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gnu-sed" => :build # https://sourceforge.net/p/gnuplot/bugs/2676/
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gd"
  depends_on "glib"
  depends_on "libcerf"
  depends_on "lua"
  depends_on "pango"
  depends_on "qt"
  depends_on "readline"
  depends_on "webp"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    args = %W[
      --disable-silent-rules
      --with-readline=#{Formula["readline"].opt_prefix}
      --disable-wxwidgets
      --with-qt
      --without-x
      --without-latex
      LRELEASE=#{Formula["qt"].bin}/lrelease
      MOC=#{Formula["qt"].pkgshare}/libexec/moc
      RCC=#{Formula["qt"].pkgshare}/libexec/rcc
      UIC=#{Formula["qt"].pkgshare}/libexec/uic
    ]

    # https://sourceforge.net/p/gnuplot/bugs/2676/
    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"

    if OS.mac?
      # pkg-config files are not shipped on macOS, making our job harder
      # https://bugreports.qt.io/browse/QTBUG-86080
      # Hopefully in the future gnuplot can autodetect this information
      # https://sourceforge.net/p/gnuplot/feature-requests/560/
      qtcflags = []
      qtlibs = %W[-F#{Formula["qt"].opt_prefix}/Frameworks]
      %w[Core Gui Network Svg PrintSupport Widgets Core5Compat].each do |m|
        qtcflags << "-I#{Formula["qt"].opt_include}/Qt#{m}"
        qtlibs << "-framework Qt#{m}"
      end

      args += %W[
        QT_CFLAGS=#{qtcflags.join(" ")}
        QT_LIBS=#{qtlibs.join(" ")}
      ]
    end

    ENV.append "CXXFLAGS", "-std=c++17" # needed for Qt 6
    system "./prepare" if build.head?
    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    system "make", "install"
  end

  test do
    system bin/"gnuplot", "-e", <<~EOS
      set terminal dumb;
      set output "#{testpath}/graph.txt";
      plot sin(x);
    EOS
    assert_path_exists testpath/"graph.txt"
  end
end
