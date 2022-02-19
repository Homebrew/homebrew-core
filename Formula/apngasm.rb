class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.6.tar.gz"
  sha256 "0068e31cd878e07f3dffa4c6afba6242a753dac83b3799470149d2e816c1a2a7"
  license "Zlib"
  revision 4
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "219c6587b5ecec5060a05735e32c55deb126562aaceb6dcbfdda341d70c8adc8"
    sha256 cellar: :any,                 arm64_big_sur:  "105eed022dae4f6baa80cb282a77f1309c9f8ff8cfac8662a992f06d0adbfe08"
    sha256 cellar: :any,                 monterey:       "24ad3bddaa293a14347b0cf5a4eedaaa4a96cbc3fb00a07b7a4f33e9d7e40684"
    sha256 cellar: :any,                 big_sur:        "6510d9c52c774ebf62478b0d4bd40fe5109d7b1c867b5c6be68b2afa2b910442"
    sha256 cellar: :any,                 catalina:       "e04e89431ce9dace1d79e858b52711fedd6ef8a44f7ca5499bbfd8e612905e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fac26c5d767fcef20f109fe26ce42648dfae3a4162389ec0849c7110102638f"
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
