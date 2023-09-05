class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.3.0.tar.gz"
  sha256 "9c00a2b4c33ff4879860eadb89f6c836062433a5debdaffbf41f98bfa83081f3"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4a65b1539a6b2743044d7493fe14d565fcf3e35dcbf22e6a355af4b7f2058f4a"
    sha256 cellar: :any,                 arm64_monterey: "c6aa39cb9fd8be033413bfe46a8b510e9a95f51beb5df693bff3bbcd0a282243"
    sha256 cellar: :any,                 arm64_big_sur:  "9929cc28a66ec265af329ca149f07a00a0baef8a67668c713d1c924f1a1b8593"
    sha256 cellar: :any,                 ventura:        "77bd84114b0e356f349ee3fd14384c06238eb3484402d7715860bc7d40ffa55c"
    sha256 cellar: :any,                 monterey:       "b984a4d3090980fc694dc72df2deb8348f4521cb9eb46496bb1d1ea9e6a0f2d1"
    sha256 cellar: :any,                 big_sur:        "c0fbd74432348bd448f9ab3be72b7c0f6f5f4a5d5804bd9a439db9a484821813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53c2c32966f135abbdf5d08d658656f0c8abbf0ead77143b2a95e54a114049b5"
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
