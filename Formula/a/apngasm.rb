class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/refs/tags/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 9
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "22cf2a9c976b819a04e172a92ce14cadfbfc8956f998a659c69ee32a894bcac5"
    sha256                               arm64_ventura:  "f0e6d6fcaac2a8434c6dc5bd3c59be4e10fe1bc17a32bae1703fe0c974d964e0"
    sha256 cellar: :any,                 arm64_monterey: "b27b1d58b5af526b74d9e88c3b22fe036bd1c3e6c3131bec335b61cb546a01e0"
    sha256                               sonoma:         "ae23fd4e7d40c020bf7b357a79c89f87ad17283d86dad6854f0be2becb940367"
    sha256                               ventura:        "60c9dc137371611f6590cbb0fa78fa3dfe81de7a24fd9fb3bf25c2d615c3009c"
    sha256 cellar: :any,                 monterey:       "f03187fa359111012c3302ab725e26a36b9ae70316e0d880b7f467b968c4a543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1624c47973dabb3fc79a6350b919e5a50dfd26b73ee82e5328311a42e3f764ab"
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
