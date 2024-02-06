class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/6.0.0/gnuplot-6.0.0.tar.gz"
  sha256 "635a28f0993f6ab0d1179e072ad39b8139d07f51237f841d93c6c2ff4b1758ec"
  license "gnuplot"

  livecheck do
    url :stable
    regex(%r{url=.*?/gnuplot[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "d92d1dc715458feb2d30d989d652c8fdd4d8dfb147bce1b45ead44bb02ceb829"
    sha256 arm64_ventura:  "8a9d03d57efcf9873c2923b142417cc62fa15892a78469db57e5ec15cb179d17"
    sha256 arm64_monterey: "904fffc29054b3cf6d5c78f548fe67f71280188c710ece1f791c1246b12fd382"
    sha256 sonoma:         "70eb518fbcfcd30c0f26a1fc8a0a3e9b575553c37f4a61c478fa8646b61e9c0c"
    sha256 ventura:        "d72c280d93c71dd20fcaf800145b5eef16242c1c0908f352347e3ca22e487d3d"
    sha256 monterey:       "38d49f29e33cd79a583575f48822189109c46d0ce27abfab82bd47300905e079"
    sha256 x86_64_linux:   "18c5a4d8d1a6314539fd4f5cadefcfc0228130d5e4ec45d4a26f99c1f6037f85"
  end

  head do
    url "https://git.code.sf.net/p/gnuplot/gnuplot-main.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gnu-sed" => :build # https://sourceforge.net/p/gnuplot/bugs/2676/
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libcerf"
  depends_on "lua"
  depends_on "pango"
  depends_on "qt"
  depends_on "readline"

  fails_with gcc: "5"

  resource "user-manual" do
    url "https://netix.dl.sourceforge.net/project/gnuplot/gnuplot/6.0.0/Gnuplot6.pdf"
    sha256 "af0f0351195eb31c5cc6d16a2713e8cdbf7ed97bc3d248a8ccbdf5236dc1413c"
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
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] },
                          *args
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    system "make", "install"

    doc.install resource("user-manual")
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
