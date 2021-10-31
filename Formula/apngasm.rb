class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.6.tar.gz"
  sha256 "0068e31cd878e07f3dffa4c6afba6242a753dac83b3799470149d2e816c1a2a7"
  license "Zlib"
  revision 5
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "266deabd148a65334b8267e4e5a2cd7be59ae83d08cd098cf5c7b4f78f7541ef"
    sha256 cellar: :any,                 arm64_big_sur:  "b561e57d6d4d3f4b62133a977dcd455acc847a283bc3a61eac50cb6204fe7274"
    sha256 cellar: :any,                 monterey:       "6aa9726bb6fd25e72ab310d3d37407208106f4ee18cb74c987d225736016f44e"
    sha256 cellar: :any,                 big_sur:        "2f249a0c49b15b99322f83fc3d77d33e160279e14a993e1336b04c2d0b84b574"
    sha256 cellar: :any,                 catalina:       "24a3a9319c7c61ec5c9a44ae287209a6f1d8ecce90ca84d22d278abdc1b0d5e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e254b0e751186dc0ffc9575454e289d3e2cca907b672943d3dd1c1f012b1bea9"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libpng"
  depends_on "lzlib"

  def install
    inreplace "cli/CMakeLists.txt", "${CMAKE_INSTALL_PREFIX}/man/man1",
                                    "${CMAKE_INSTALL_PREFIX}/share/man/man1"
    mkdir "build" do
      ENV.cxx11
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    (pkgshare/"test").install "test/samples"
  end

  test do
    system bin/"apngasm", "#{pkgshare}/test/samples/clock*.png"
  end
end
