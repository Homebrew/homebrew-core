class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/6.0.6/gnuplot-6.0.6.tar.gz"
  sha256 "9d39d8499c9533550144092375aac45ba8bf0c18c9cee50897fe411b6d93004e"
  license "gnuplot"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/gnuplot[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_golden_gate: "2fd945496dc795654ebf62ecb365fcfb6fd7b37b5eed6561ccbc885e8dca2849"
    sha256 arm64_tahoe:       "b4699393b6588be003f891e0fd87836a10024d11e10b3cff71cdb9aabd53ac1f"
    sha256 arm64_sequoia:     "5359d6afc0ddef2ed2f1f283f9ca50b66d6acca3f72b8976ea6b8008e098d293"
    sha256 arm64_linux:       "93d755518376d97d006c73a8fffe249d66eb7fcb19ab3fe13bad0e6f402dfc4d"
    sha256 x86_64_linux:      "971767f481066ec6d1842eaf86cc2cdd99ce2f2ad3ba545942d8ad9522e9d07d"
  end

  head do
    url "https://git.code.sf.net/p/gnuplot/gnuplot-main.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "qttools" => :build

  depends_on "cairo"
  depends_on "gd"
  depends_on "glib"
  depends_on "libcerf"
  depends_on "lua"
  depends_on "pango"
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "qtsvg"
  depends_on "readline"
  depends_on "webp"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  deny_network_access!

  def install
    args = %W[
      --disable-silent-rules
      --with-readline=#{formula_opt_prefix("readline")}
      --disable-wxwidgets
      --with-qt
      --without-x
      --without-latex
    ]

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
