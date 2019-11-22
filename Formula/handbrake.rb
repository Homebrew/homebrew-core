class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://download.handbrake.fr/releases/1.3.0/HandBrake-1.3.0-source.tar.bz2"
  sha256 "a9a82eb5ca04a793705b3d7d11cefa29946694eeb13b40161446aaca35b31d96"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd30221643e98ef2bb7fd47a698fe3206bea7ffbb920dcf7cca1551aaa61c488" => :catalina
    sha256 "a8d970465d2fd15f53b109a5efdfa19be785da8f71f9193f73cc9134817fad14" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on :xcode => ["10.3", :build]
  depends_on "yasm" => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-xcode",
                          "--disable-gtk"
    system "make", "-C", "build"
    system "make", "-C", "build", "install"
  end

  test do
    system bin/"HandBrakeCLI", "--help"
  end
end
