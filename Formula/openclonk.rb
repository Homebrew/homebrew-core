class Openclonk < Formula
  desc "Multiplayer action game"
  homepage "http://www.openclonk.org"
  url "http://www.openclonk.org/builds/release/7.0/openclonk-7.0-src.tar.bz2"
  sha256 "bc1a231d72774a7aa8819e54e1f79be27a21b579fb057609398f2aa5700b0732"
  revision 1
  head "https://github.com/openclonk/openclonk", :using => :git

  bottle do
    cellar :any
    sha256 "481eec5556eaee344b87562f8744cef8eebab542fbd0111266d52e8ec3ec5542" => :sierra
    sha256 "a643463cf54b88b32455e686b76f83f614d4f02da77c4158f751fa56e5b67822" => :el_capitan
    sha256 "ea319199ef6666ce4661851d1baa4afb637c99ee42ff512eb9cb6fa0e1425312" => :yosemite
  end

  # Requires some C++14 features missing in Mavericks
  depends_on :macos => :yosemite
  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "boost"
  depends_on "freealut"

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
    bin.write_exec_script "#{prefix}/openclonk.app/Contents/MacOS/openclonk"
    bin.install Dir[prefix/"c4*"]
  end

  test do
    system bin/"c4group"
  end
end
