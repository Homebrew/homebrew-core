class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.3.1.tar.gz"
  sha256 "800326514c9ef5c75e4177b4f51398714fb8117b809181ef7fe7fe30515b3aa2"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "66b7acbe58629d1961068334cf2038b2a095579380fa9f54a9b8fdbfb8b30fda"
    sha256 cellar: :any,                 arm64_ventura:  "b8001049ad7fb673df3b130a9367a86cd18dbdc897919fe4c2b2a8bae56f7352"
    sha256 cellar: :any,                 arm64_monterey: "048d7bf77f0f741691a61456b9c246dad0f1e8703fecf6ec899ebcc6c35e2b4b"
    sha256 cellar: :any,                 sonoma:         "64de5bba9a986a135aec472e6d1d6c32e5162592e1fd69ae821a4ee4791712b3"
    sha256 cellar: :any,                 ventura:        "b6dedfba73d53f30b3fb56b90ddeccadcc1505e0c1352ecacc6d458b12cc1e86"
    sha256 cellar: :any,                 monterey:       "524479032342f1016893be7173ed035317880e0ff173909c813ccf3fe8ae72dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19331336efcbf7d3eae8b9e0603a8baca14f9a935a55ed01e265a63b5378d39e"
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
