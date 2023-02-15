class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.2.1.tar.gz"
  sha256 "95881919b2e94de502abade0472d27535f7cfa9d17741d8dc0a6b13d4152c175"
  license "CECILL-2.1"
  head "https://github.com/dtschump/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "98d5024c9f6dd436b1dc66dcf871d298217d01fb1de84cc858c81e1793391b4f"
    sha256 cellar: :any,                 arm64_monterey: "ea3fb8d3eae5e6656f4f032c5ebbc5c4d9dbcb4f114ac3e613adf221af30dbce"
    sha256 cellar: :any,                 arm64_big_sur:  "9975284fcb7a6dbf25937e3f1c880353b4baa1b5f929f6e8d300aca9eb279bad"
    sha256 cellar: :any,                 ventura:        "a389a7f6b91fc7988fb1a60930e80a7baa7aaa58bb6564ac535317d764a07811"
    sha256 cellar: :any,                 monterey:       "3170630cddf1b4d5f326292df69a555880644cb1ea2ca5a644f9cdfa87875bc4"
    sha256 cellar: :any,                 big_sur:        "b4f5ebd2ef5bf286de5fd81475d35dc9dd8976f658d5fa9810214fd417ba4f05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1c7d07dc41b9f68189f717f5f2f7e06ae8b7312cbe9bb52cc18609e1a6ec579"
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
