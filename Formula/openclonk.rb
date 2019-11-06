class Openclonk < Formula
  desc "Multiplayer action game"
  homepage "https://www.openclonk.org/"
  url "https://www.openclonk.org/builds/release/7.0/openclonk-7.0-src.tar.bz2"
  sha256 "bc1a231d72774a7aa8819e54e1f79be27a21b579fb057609398f2aa5700b0732"
  revision 2
  head "https://github.com/openclonk/openclonk", :using => :git

  bottle do
    cellar :any
    sha256 "210a3ff7a897e476db83eff28e4dad3ea6e56d0fd1df0161a63bf34214fd71dc" => :catalina
    sha256 "e15174b64e0999fcd66abbc585e8c0b789e047bd59df85577f7fe7e3937e5cf6" => :mojave
    sha256 "056037f1d797495cce2b0c28be28e76c49a318a339443b48c141a43ca0d871f1" => :high_sierra
    sha256 "101621b7af46c82184ad302b2246a6d76abfa3c14ad46a7c810dafaedea87051" => :sierra
    sha256 "ce6e5259b6e04779c378221974cdfee36382976aa5ec266804e57f2bad1730f8" => :el_capitan
    sha256 "e3ebb625a585702c150f2f74aa71fca61d6bf5d61085fe31e6b42ac42d68ede6" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "freealut"
  depends_on "freetype"
  depends_on "glew"
  depends_on "jpeg"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  # Requires some C++14 features missing in Mavericks
  depends_on :macos => :yosemite

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
