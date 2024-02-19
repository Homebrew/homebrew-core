class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.3.3.tar.gz"
  sha256 "903937d6475878df1e2130eee32d1fd93c4597bd2ef7f94e1d9775da1839645d"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c017182de383ceeb1c847248f7e88d6b25ac4ab6cfc7f9709fefa2969a656147"
    sha256 cellar: :any,                 arm64_ventura:  "2dcbd3e565151fbf658d82f073a0482f4672e4da608f2d389918558f567a71ae"
    sha256 cellar: :any,                 arm64_monterey: "5602408e543eb44f5e07621d31fcdc0b63d6184bf5a9f7066f72159209abd0f5"
    sha256 cellar: :any,                 sonoma:         "c4710e4e00626b1ecda687c0c938d39ae6251699c79f9f205ca30dd500fc4105"
    sha256 cellar: :any,                 ventura:        "0979eaeb8c7e1d6cb2756382dda1608b256e21b097a36924af760a00b9b79d7f"
    sha256 cellar: :any,                 monterey:       "2d1d7d17c60d1ab8deae26aa4d176e106419ec13f7d24bcd3a652c514bc67f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdd18bded3d129a1b2009d82a0faeba92e40d0fd26f1314c8041fc347dff126d"
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
