class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/6.0.4/gnuplot-6.0.4.tar.gz"
  sha256 "458d94769625e73d5f6232500f49cbadcb2b183380d43d2266a0f9701aeb9c5b"
  license "gnuplot"

  livecheck do
    url :stable
    regex(%r{url=.*?/gnuplot[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "84aa92c8f37df3670debec51a5f814b8012ee27805e179d4928cf4c6348c07c6"
    sha256 arm64_sequoia: "6786833abaf3ace2b368b7a71039b4dc3ac19143c7a68811949293cc635b2c20"
    sha256 arm64_sonoma:  "2c4cfbe7ed0015117c8749940eebe26d9ed1c44eda5db3fc195ef23a2d7b0db8"
    sha256 sonoma:        "dcbbb1ba4a60c36591d13df4ee978f7a548b40e4e18c809e9b6be821a9a9ba36"
    sha256 arm64_linux:   "9ed032636aabdeb38b89739653f18f4f87e9f36b5664051c2502ca62044b39f2"
    sha256 x86_64_linux:  "3c9c387f8b3c2db2e20783ac054fd384b8233f9447d34e39e7b8e9e520b43529"
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
