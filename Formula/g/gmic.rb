class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.3.4.tar.gz"
  sha256 "f52c5c8b44afe830e0d7e177a1477621821f8aa2e5183f8a432970a17acfa0bb"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "423f97ef38164621dc904d4783dc327f65d5d3428ba4c911a928de54c77c7a42"
    sha256 cellar: :any,                 arm64_ventura:  "bd1fd2a455bb56b62e2bab5ac8380826e6f0b6dd2dc710bb546aac6bc5d6c0e4"
    sha256 cellar: :any,                 arm64_monterey: "77035a3113827bcb85d23fc417ce0da4180475545fa7baab9aa5c4fab5b3c2fc"
    sha256 cellar: :any,                 sonoma:         "684226bd9b88de8dfb371bb1692f8091833ada283adae2357b722520a309bb15"
    sha256 cellar: :any,                 ventura:        "f5352ddb96b2c1a6997c70f8637cd3180153db1e676768e78572d4fd4c2b59ed"
    sha256 cellar: :any,                 monterey:       "048c584f771f173a29bdb41a0da31f1915d520769456fed9e2bb3d27ff93a649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a65fcd384a17292da8fe3f60078b5ad037325a8661010a9fded0ad94d024327"
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

    if OS.mac?
      # The Makefile does not install the dylib and gmic.h, so we need to
      # install them manually.
      ln_s "libgmic.#{version}.dylib", "src/libgmic.dylib"
      lib.install "src/libgmic.#{version}.dylib"
      lib.install "src/libgmic.dylib"
      include.install "src/gmic.h"
    end

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
