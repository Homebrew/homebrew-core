class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.2.5.tar.gz"
  sha256 "ae1a903df27e3131702c27b6fea6bdd8faabd756f53e22d3f35fb790f22d2035"
  license "CECILL-2.1"
  revision 1
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b0169fe91d54e4f5ccc5760c14d29b3a0e5bd059d36b31731162f1765a6d79cc"
    sha256 cellar: :any,                 arm64_monterey: "2ac832b6f13d87fa6ded9f7149bf87e8671de0ff328b40d7e354d8d6fa93aea6"
    sha256 cellar: :any,                 arm64_big_sur:  "7943ba2c6990c432c972c414c575d3b1e3a430fd61e1d092129bab4fd9fd05ba"
    sha256 cellar: :any,                 ventura:        "d5ef425d2f5f71ea96a3c0c78e4e8bcd180564329213f2a5c684e98d2e59799a"
    sha256 cellar: :any,                 monterey:       "43d00251c0005cdddea7d8620c4d169c5d08a6a7a4b5a2cc71cc87451e592af1"
    sha256 cellar: :any,                 big_sur:        "39e0405a8ef8472fffb497da700ce245ae4b5b483c6a7ba92290562ab232fcdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03b165c5427892d4050ffb18cdf8b60d44ec93a8eaed7dcb248f57057cdcda6e"
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
