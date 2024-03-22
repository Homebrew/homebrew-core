class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/refs/tags/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 10
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "0be3d7e61f04fb40e341bf388d29e0e131af04e02dea04d28d95ed4bcbf5b7f4"
    sha256                               arm64_ventura:  "347cc7acc24bbba3ba3ebddef2a7dd07fc0f04ba84ddd80744730af9451f1989"
    sha256 cellar: :any,                 arm64_monterey: "68ac9b3b5e37fdfab9dcea8c512c43d02577fc4cf791a16d9458169ddbd6f095"
    sha256                               sonoma:         "1b6de049e9e2a9122f2a930481847ed7d9731b2c883bb1d3f98bbf9de1115afc"
    sha256                               ventura:        "ac64ee488ccfa95a902f711e9cf0ca845f35d1c097314a77541bc8c59527a646"
    sha256 cellar: :any,                 monterey:       "6a10a7127e873b3eacf4aaaac2c4278561c9eaf86ea75e7bf41b59f86e4f36ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4da6625f705ee3c23647e62b6e9fa1bba95556079f1d68796f9d84611496f527"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "lzlib"
  depends_on macos: :catalina

  fails_with :gcc do
    version "7"
    cause "Requires C++17 filesystem"
  end

  def install
    inreplace "cli/CMakeLists.txt", "${CMAKE_INSTALL_PREFIX}/man/man1",
                                    "${CMAKE_INSTALL_PREFIX}/share/man/man1"
    ENV.cxx11
    ENV.deparallelize # Build error: ld: library not found for -lapngasm
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"test").install "test/samples"
  end

  test do
    system bin/"apngasm", "#{pkgshare}/test/samples/clock*.png"
  end
end
