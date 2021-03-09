class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.6.tar.gz"
  sha256 "0068e31cd878e07f3dffa4c6afba6242a753dac83b3799470149d2e816c1a2a7"
  license "Zlib"
  revision 1
  head "https://github.com/apngasm/apngasm.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e939020f3749911eb164d7fa1703ed627dfe82a9721747019aa2c8408ab33e98"
    sha256 cellar: :any, big_sur:       "989fab4ac0fef9191cc97100d9a6aa84e559d01b1adc2026f8b1dd8e300a2550"
    sha256 cellar: :any, catalina:      "d77102b0795a702c5c0c84b96b6ea06d6c96d33a8e9bf70dcdbb170cf932869f"
    sha256 cellar: :any, mojave:        "bab451c492901331dc7ff809aa1d553c9a5069e65cbbe8834ecfa2a771f102cc"
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
