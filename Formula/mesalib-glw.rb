class MesalibGlw < Formula
  desc "Open-source implementation of the OpenGL specification"
  homepage "https://www.mesa3d.org"
  url "https://mesa.freedesktop.org/archive/glw/glw-8.0.0.tar.bz2"
  sha256 "2da1d06e825f073dcbad264aec7b45c649100e5bcde688ac3035b34c8dbc8597"
  license :cannot_represent
  revision 1

  bottle do
    cellar :any
    sha256 "9580a442aa0843b284317be696caa8742165a1574d20e8398c9fadbdfc426dc6" => :big_sur
    sha256 "fed357436c36aa832c46cad896d75a9b3f0015658732af9cad3a18b19769ea72" => :arm64_big_sur
    sha256 "1a1690918045f775ea6d71216a5b674b5762556aeaf0285e70533150aa7f14b6" => :catalina
    sha256 "39c625451d18574ed9b9fcd6383c3a3e3b0ac7633f85d28df97a3594ea02e37a" => :mojave
    sha256 "fdd89421a230f4b3ea4c2b73cae82cd37d3b44bc61afd5b9e7274dc23491dc8b" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxt"
  depends_on "mesa"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end
end
