class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.6.tar.gz"
  sha256 "0068e31cd878e07f3dffa4c6afba6242a753dac83b3799470149d2e816c1a2a7"
  license "Zlib"
  revision 2
  head "https://github.com/apngasm/apngasm.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9f447e672e2a167926aba3a733123ad244be88f5814dbf86dff970394537abf4"
    sha256 cellar: :any, big_sur:       "6cbad5185766695cdf400d99aae063ea9d6c97e39b4ef1e56d5b74c98abcb359"
    sha256 cellar: :any, catalina:      "31d5d3176ba5d537d34ca05e9a10a3d61b60a625545fe03250c6329a0463d341"
    sha256 cellar: :any, mojave:        "7ce45f6142f41d016eddded9324a7a65dd9921d2156f2d4fe2cadc3e1f991e6e"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libpng"
  depends_on "lzlib"

  def install
    inreplace "cli/CMakeLists.txt", "${CMAKE_INSTALL_PREFIX}/man/man1",
                                    "${CMAKE_INSTALL_PREFIX}/share/man/man1"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    (pkgshare/"test").install "test/samples"
  end

  test do
    system bin/"apngasm", "#{pkgshare}/test/samples/clock*.png"
  end
end
