class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/6.0.2/gnuplot-6.0.2.tar.gz"
  sha256 "f68a3b0bbb7bbbb437649674106d94522c00bf2f285cce0c19c3180b1ee7e738"
  license "gnuplot"

  livecheck do
    url :stable
    regex(%r{url=.*?/gnuplot[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:  "d55e5f3a895e0243bf3f91b03f71a17beee8dd32f7578a9fbf47e37d55310769"
    sha256 arm64_ventura: "5818dec5b5211897a75d4a838cccd7d384081f560b7948ef982484de20d57581"
    sha256 sonoma:        "e5ec734e9a605d93fe3cb3715e5268ebee7e2c781980541c20999d23f4b06498"
    sha256 ventura:       "ba8549eb440ca125cf18d887d1e9b2f8aa1ff5b5e69e21c832882785b9765057"
    sha256 x86_64_linux:  "24e1fe6413ac0e870b46fbcafa02cc3df6636834b0a410ada0d7d462f51af527"
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
