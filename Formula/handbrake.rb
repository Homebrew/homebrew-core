class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://download.handbrake.fr/releases/1.3.0/HandBrake-1.3.0-source.tar.bz2"
  sha256 "a9a82eb5ca04a793705b3d7d11cefa29946694eeb13b40161446aaca35b31d96"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "534166801eb1c879babba506733d839e563bad09a5420b0b9d7b0ccc741d2a30" => :catalina
    sha256 "58a3e271b88e38cd986eda9ec3f87e4807c4bb782c72134420115891e6b77adb" => :mojave
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
