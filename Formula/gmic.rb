class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.2.6.tar.gz"
  sha256 "55993e55a30fe2da32f9533b9db2a3250affa2b32003b0c49c36eec2b2c6e007"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "af8dcc248995ba79019cd490b80258a1afb8eec7fcb7f0f317ca5860f95ccbac"
    sha256 cellar: :any,                 arm64_monterey: "228e98960e94ce29af2adf1d1aca78837176b7504957143d9cd15180ec5dda98"
    sha256 cellar: :any,                 arm64_big_sur:  "84bd46cd387916397daa14303877ee5b56f773bc766ebb58c164ae7ee9d34b99"
    sha256 cellar: :any,                 ventura:        "970e878955061bf68a212400b9c219cc8de8776ac2d431614c0467a471a153e5"
    sha256 cellar: :any,                 monterey:       "9639de0c722952bb6bea2af4a9d2e4957f0c7a95266d0ef25d7191049121f2a0"
    sha256 cellar: :any,                 big_sur:        "9eb871a19c482c244e367b7513225aba05f801bbbf595a87221ea2f96ad3c007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cae040fe5358ac7ce3d20e6e4c30eabef88b8f154123c5b969b80c294cc8dfe2"
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
