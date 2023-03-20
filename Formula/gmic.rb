class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.2.2.tar.gz"
  sha256 "c747496c8eece456f0e3404daca1b99ee94ddb694770970f220e2a62de803a58"
  license "CECILL-2.1"
  head "https://github.com/dtschump/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3746ec97c1011d8f964c62e4e98bf812dcde2bc3e2f18112934d1560a371cd51"
    sha256 cellar: :any,                 arm64_monterey: "0e5b5a2c62c0d1c1c4ab37235f292fccb6c9b113d87513afeafa24f9b3551509"
    sha256 cellar: :any,                 arm64_big_sur:  "14c3b143024f2229027dfd03a94e66a074c32ccbdaadab983fe58caf473b4774"
    sha256 cellar: :any,                 ventura:        "f89d9a4f779abcb2d57214ab4b61e00f1008b4d7d6f91f591715bdf09f09aa6e"
    sha256 cellar: :any,                 monterey:       "a81676ae8396eb5eaeed9c3a2c1669f8e6c98476a19de1156dca3d6f897e1fc2"
    sha256 cellar: :any,                 big_sur:        "7c1401e2167685e4e7e6810ff834a1bce7678467a5f5eb67e77338eb2a8a92e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c13569b7cd535fee0412ef364d985946005c5ea92c69d4ffab995c5753ddfb5"
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
