class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.2.1.tar.gz"
  sha256 "95881919b2e94de502abade0472d27535f7cfa9d17741d8dc0a6b13d4152c175"
  license "CECILL-2.1"
  revision 1
  head "https://github.com/dtschump/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "17fc9e3ea98cdf39126c609e384f9cea10d690d2bdf62d860db938c3658644f7"
    sha256 cellar: :any,                 arm64_monterey: "1b8492650dd7bf7bb2fda2379ef4edda319a923019e8f7639993cb8ad337d27d"
    sha256 cellar: :any,                 arm64_big_sur:  "736bf612c507bdde09a5c781c3edad094b7dd57b9bc503675eb938b1ff6386a4"
    sha256 cellar: :any,                 ventura:        "69a3516db58a1314aa9417d7ebeab4fed734a025a97c1330ee657bffdb9c7203"
    sha256 cellar: :any,                 monterey:       "126bc5af0994195bb6a6c07768cede6c6c0adff28ec48bc0d26dfc6f0db4dda2"
    sha256 cellar: :any,                 big_sur:        "cafda78c77d896e382049692618c31b1e100a2ed639fc84041ece9213f48042f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3318b025a41a58d90ef85c7633fafd7ec6ffcc406ae647e790d613c8904bcaf"
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "bash-completion"
  end

  # Use .dylibs instead of .so on macOS
  patch do
    on_macos do
      url "https://raw.githubusercontent.com/macports/macports-ports/a859c5929c929548f5156f5cab13a2f341982e72/science/gmic/files/patch-src-Makefile.diff"
      sha256 "5b4914a05135f6c137bb5980d0c3bf8d94405f03d4e12b6ee38bd0e0e004a358"
      directory "src"
    end
  end

  def install
    # The Makefile is not safe to run in parallel.
    # Issue ref: https://github.com/dtschump/gmic/issues/406
    ENV.deparallelize

    # Use PLUGINDIR to avoid trying to create "/plug-ins" on Linux without GIMP.
    # Disable X11 by using the values from Makefile when "/usr/X11" doesn't exist.
    args = %W[
      PLUGINDIR=#{buildpath}/plug-ins
      USR=#{prefix}
      X11_CFLAGS=-Dcimg_display=0
      X11_LIBS=-lpthread
      SOVERSION=#{version}
    ]
    system "make", "lib", "cli_shared", *args
    system "make", "install", *args, "PREFIX=#{prefix}"
    lib.install "src/libgmic.a"

    # Need gmic binary to build completions
    ENV.prepend_path "PATH", bin
    system "make", "bashcompletion", *args
    bash_completion.install "resources/gmic_bashcompletion.sh" => "gmic"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin/"gmic", test_fixtures(file)
    end
    system bin/"gmic", "-input", test_fixtures("test.jpg"), "rodilius", "10,4,400,16",
           "smooth", "60,0,1,1,4", "normalize_local", "10,16", "-output", testpath/"test_rodilius.jpg"
    assert_predicate testpath/"test_rodilius.jpg", :exist?
  end
end
