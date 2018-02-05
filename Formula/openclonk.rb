class Openclonk < Formula
  desc "Multiplayer action game"
  homepage "http://www.openclonk.org"
  url "https://github.com/openclonk/openclonk/archive/v8.0.tar.gz"
  sha256 "3cc6e2ff992221c1df0abbab7ad20cb4fd9cf131149c5857655b06fba38cb332"
  head "https://github.com/openclonk/openclonk.git"

  bottle do
    cellar :any
    sha256 "056037f1d797495cce2b0c28be28e76c49a318a339443b48c141a43ca0d871f1" => :high_sierra
    sha256 "101621b7af46c82184ad302b2246a6d76abfa3c14ad46a7c810dafaedea87051" => :sierra
    sha256 "ce6e5259b6e04779c378221974cdfee36382976aa5ec266804e57f2bad1730f8" => :el_capitan
    sha256 "e3ebb625a585702c150f2f74aa71fca61d6bf5d61085fe31e6b42ac42d68ede6" => :yosemite
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
