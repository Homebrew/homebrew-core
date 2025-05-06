class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/refs/tags/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 17
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "9f9562c52caf37166d3771a0e370250319750ce9fa016ca099ee231ba4ae88d3"
    sha256                               arm64_sonoma:  "f0791efcfc25b7001706e2e2bdcb1f9120d8cf5fd1c34a1fefdfb09056b492dc"
    sha256                               arm64_ventura: "3d82122ccb48a72935372aac4a7952a4a078b8e1918704e3f68ed4feb50bc225"
    sha256                               sonoma:        "fc995725850b2752e9f442bf63eee3cffd43a4454a48429edd57cbeab2b4356c"
    sha256                               ventura:       "c37625e57630e64210b78c4621173c635fc6fe567c2a334fcce25b5c0723017e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b9da2361fb8475de751ce0eadc113311b992916637e11fd1e70c00d579b4ec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7176fba311bf1861d06e2f5cab3172ec487c50aa1aaaa8ca84d7adf14d52f5cb"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c@77"
  depends_on "libpng"
  depends_on "lzlib"
  depends_on macos: :catalina

  uses_from_macos "zlib"

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
    system bin/"apngasm", pkgshare/"test/samples/clock*.png"
  end
end
