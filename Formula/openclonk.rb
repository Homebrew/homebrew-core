class Openclonk < Formula
  desc "Multiplayer action game"
  homepage "https://www.openclonk.org/"
  url "https://www.openclonk.org/builds/release/8.1/openclonk-8.1-src.tar.bz2"
  sha256 "337677f25457e7137eac7818adb4ad02992d562593386c19b885738aaec4b346"
  license "ISC"
  head "https://github.com/openclonk/openclonk.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ebd7f7efa0efc4c70b14071e98a5f2d314c16e5b6f28fe11257738619f0c813b"
    sha256 cellar: :any, big_sur:       "1f4cca43144a36b7d6eeb24d9d3cefc84b591fb20abc503ecca7e73fc26b07ca"
    sha256 cellar: :any, catalina:      "95f44dd3686157a5185f1452f46515160347cef55237aac391edfabbbeb0c5de"
    sha256 cellar: :any, mojave:        "688963d2df4cd964a51bed317cf656137d5e8d668b457a7cef89e8302ac02f49"
    sha256 cellar: :any, high_sierra:   "87779de2d3cfa0dc1880fa45226e3f434ecca4409565db5e8bf278c225487da1"
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
