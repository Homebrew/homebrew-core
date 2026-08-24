class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/6.0.5/gnuplot-6.0.5.tar.gz"
  sha256 "73237f37f03306d68bfae133a9a50d5e9341384e198d5ab37eeca9ab534deed8"
  license "gnuplot"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/gnuplot[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "a153d761ec3f1cdae50e78d877fd03cb4f4ecc3116e5797649d97f9b1afab4ed"
    sha256 arm64_sequoia: "3d8efad2b1ce4cd0c1b450e879eb5eec1f4e0faed7d49e0c966f457d70153eb1"
    sha256 arm64_sonoma:  "96dbce83ca48877b9ba0b150e44bde0dce1f6d4e579f0c26a38c921ebd134bb5"
    sha256 sonoma:        "9797e19149b8cbeadce635e323996a5db07b9a8449a16c5b639ce0b5b1f8ee93"
    sha256 arm64_linux:   "b39ea1e52915400931003a9aa108d53b852bbb7edad46be7118c0f6bdc4fc5e4"
    sha256 x86_64_linux:  "d5d06f7e58bac89c438d57c31df65248ecc23d40b4ffad276afc30c201409917"
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
