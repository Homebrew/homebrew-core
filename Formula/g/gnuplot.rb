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
    rebuild 2
    sha256 arm64_tahoe:   "955fa674228be8dfeaeaaff768395a020923d859dc68a3f310488247e3ce4415"
    sha256 arm64_sequoia: "09d2a9f66dfc73e37386e1223398a68d5ce218be88c1071aa718163d9ed61048"
    sha256 arm64_sonoma:  "48dd121ea7f5d69f691e0388bf2c2b6361c3bb70183157198ae96ac40838c7d1"
    sha256 sonoma:        "3bdf53b8e9713d484b746bd7b9abe32f8d636fbbaa658edddcbe2d1e15b3d965"
    sha256 arm64_linux:   "facb27cb1f528d403d1680de96d6ec069ee47bb71c4fd3b964f2877f50f6cb9b"
    sha256 x86_64_linux:  "d72dfd859cb4e2332bde4404b84e8158b8395a0a887b0a0f9f24a98d5125baa6"
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
      --with-readline=#{Formula["readline"].opt_prefix}
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
