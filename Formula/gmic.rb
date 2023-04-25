class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.2.3.tar.gz"
  sha256 "c8444f0aae428a5ed555ddd809c9a4b144b4c9bb29f81057393893c34b1ac0e4"
  license "CECILL-2.1"
  head "https://github.com/dtschump/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c873d15189f277f0b2c5f92ec9fec7ad8a5013f15fdffa1f7e7ee011ac4cf60e"
    sha256 cellar: :any,                 arm64_monterey: "f629a5614974dbfdbab40a6eea27a7e5df58909ecda1b03b8711f27af7a1f3dc"
    sha256 cellar: :any,                 arm64_big_sur:  "bfcbbaed2c3180ad713befe3998c1ed38dd5f71e9137a2bd4f7b3fa545db07ac"
    sha256 cellar: :any,                 ventura:        "ced7500e257819ede4c38d649253dc9a38567baf36ccd526b445c2cee6998359"
    sha256 cellar: :any,                 monterey:       "325fb7bb3343df1a74a917b2c69f15c670c680f2204faac8c1931a19f97c0928"
    sha256 cellar: :any,                 big_sur:        "3e49c1fcefb6280f1de64c55b71cf0ebb9745956fc21eb697139f38693ab2c72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "652a03aed76dddff2e8185a4f8e528adccbb6a3838ff33ae2322408647cc8531"
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
