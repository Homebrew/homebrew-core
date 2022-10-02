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
    sha256 cellar: :any,                 arm64_monterey: "c4695a687fe50770a04247de2b403f5baecb1ab1ce71646bdcf90483046377d8"
    sha256 cellar: :any,                 arm64_big_sur:  "eae7c4b071fd61a508978708ded5ab272d43634122b7480566b369bee918e84b"
    sha256 cellar: :any,                 monterey:       "e0360d49276b222dca348523b08f72406d57ae92085c8ad7240a905230bc60fd"
    sha256 cellar: :any,                 big_sur:        "efe20f281b18e825d282c0672f9b4bd525cac7d6e2dd971213ab95c1db555ee5"
    sha256 cellar: :any,                 catalina:       "864e83816816e75e1f39a7f448d5e1cc204073956806cdfcbc289a78f52ba220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e61637e97caf2fdd854f10c685ef304731a607a8a4e0161d49b0dcfeeac08ef"
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
