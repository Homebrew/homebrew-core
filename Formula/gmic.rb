class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.2.5.tar.gz"
  sha256 "ae1a903df27e3131702c27b6fea6bdd8faabd756f53e22d3f35fb790f22d2035"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cd1ea50814e73e61323c523aae62ac984c49cb0d2d45cfa03275c51ca94c057a"
    sha256 cellar: :any,                 arm64_monterey: "fb3a1c155b8b6af8a279b21a2ad19d56b3778990b5e2adbe6416c5be477f4bc0"
    sha256 cellar: :any,                 arm64_big_sur:  "472b6af95974fe7c0627f2714e6b7b2a2be851be1c15a0b73c176e0ad1f580b7"
    sha256 cellar: :any,                 ventura:        "80ed34f41f3a03b1dd445eb544b4f68166fc2cf02260b7aee54bab126698047a"
    sha256 cellar: :any,                 monterey:       "830c8776b9902473abae9b96f2ab08681a53c038ca008f74227a1fb68c6b510f"
    sha256 cellar: :any,                 big_sur:        "fa2b31d737a531ef3c82165f3b74a5887a36106e01d99b70119655762072f332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20f33abae7d38140c1bdb0dc42cb5e6b3b4abe4c011261bda86481145583cef7"
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
