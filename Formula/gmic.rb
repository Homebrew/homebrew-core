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
    sha256 cellar: :any,                 arm64_ventura:  "e89d85e222c15aec44c7f0f546aa6c9566f2c56c5d07163535b81d2dc4803901"
    sha256 cellar: :any,                 arm64_monterey: "a8262640bb75551c27335ea30abba607c4db7711fe7d23ad2954d894386326cb"
    sha256 cellar: :any,                 arm64_big_sur:  "258c36f2c8831e02034b0184a38bba434db60b11067064023622169e545b3b09"
    sha256 cellar: :any,                 ventura:        "522b4bfc280d09e97c800f4bf8af63ba079c8db97a72f418e8111b2cd9122759"
    sha256 cellar: :any,                 monterey:       "6ef8093beb037c4a0f0709c7e72b19a1caeb6db6cefe6ff5a03ceed2ebeed3d7"
    sha256 cellar: :any,                 big_sur:        "f154cbdaa8d2eb6f4d47525c273b3337109ecf9d236a5a02fa5bb0c26783a1dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eaf722affb5afa812dd69fcdce9cb76d116b61096754cf6987e71934ac7abba"
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
