class Openclonk < Formula
  desc "Multiplayer action game"
  homepage "http://www.openclonk.org"
  url "http://www.openclonk.org/builds/release/7.0/openclonk-7.0-src.tar.bz2"
  sha256 "bc1a231d72774a7aa8819e54e1f79be27a21b579fb057609398f2aa5700b0732"
  revision 1
  head "https://github.com/openclonk/openclonk", :using => :git

  bottle do
    cellar :any
    sha256 "cb8bd950dbd4a87de03c4d4566d3d8fe4b3784a0b7e9df06fceb3a275ab751fa" => :sierra
    sha256 "82c939d749bd1f3d71b91c2068651da54f94103eaefd6897bc2916aac6f93aac" => :el_capitan
    sha256 "3abd38587a1732fb207c720b78b8b001d83574c93276b5caba39a89852a2bdf2" => :yosemite
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
