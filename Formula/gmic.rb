class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.1.6.tar.gz"
  sha256 "e73d63ba6520637c782b6e5e6805037a27b6255c011c9e2a60a56f9c28822ce4"
  license "CECILL-2.1"
  head "https://github.com/dtschump/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "72dcacdcda2094a8e45e3e661c90f6212dc4a318770cf96e1663959f6615adb7"
    sha256 cellar: :any,                 arm64_big_sur:  "71d73eaa67e5f4d725a99b97da172060590db4372f8ee66998cb928e0df75da5"
    sha256 cellar: :any,                 monterey:       "69bcbea5efe9cdb517b4845f2cd68098fc49f562c8ce7120a350698811b760e9"
    sha256 cellar: :any,                 big_sur:        "30f5ff5725f9a534e53b00f20131eac293fddc06e1be616af8e537eca7dabe7a"
    sha256 cellar: :any,                 catalina:       "17237ebe1d43273a2a0862f90162f5e5a3f8bf59083f31bbe313082095565ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06a19742505766b9ae1c10405eaa585381dd8e2d3d22de9b23f148bb2c7d9ef6"
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  uses_from_macos "curl"
  uses_from_macos "zlib"

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
    system "make", "install", *args
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
