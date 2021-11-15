class Openclonk < Formula
  desc "Multiplayer action game"
  homepage "https://www.openclonk.org/"
  url "https://www.openclonk.org/builds/release/7.0/openclonk-7.0-src.tar.bz2"
  sha256 "bc1a231d72774a7aa8819e54e1f79be27a21b579fb057609398f2aa5700b0732"
  license "ISC"
  revision 3
  head "https://github.com/openclonk/openclonk.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "7934144ac831d263bb0c51284f06f2bcac0004cf395d0404c52b1f3bf1c0189b"
    sha256 cellar: :any, arm64_big_sur:  "ebd7f7efa0efc4c70b14071e98a5f2d314c16e5b6f28fe11257738619f0c813b"
    sha256 cellar: :any, monterey:       "4210b30b0f2c1b7090eee8aa91c325a125f8305f65a3305066ac554ff84619f8"
    sha256 cellar: :any, big_sur:        "1f4cca43144a36b7d6eeb24d9d3cefc84b591fb20abc503ecca7e73fc26b07ca"
    sha256 cellar: :any, catalina:       "95f44dd3686157a5185f1452f46515160347cef55237aac391edfabbbeb0c5de"
    sha256 cellar: :any, mojave:         "688963d2df4cd964a51bed317cf656137d5e8d668b457a7cef89e8302ac02f49"
    sha256 cellar: :any, high_sierra:    "87779de2d3cfa0dc1880fa45226e3f434ecca4409565db5e8bf278c225487da1"
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
