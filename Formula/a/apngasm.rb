class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/refs/tags/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 19
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:   "23d3e8adfa479edcb2b2f37b4609afa91e898d2120cf810913139a9aa5da9a6a"
    sha256                               arm64_sequoia: "7410b645d60a0841b47dce654750b6d900f85f21684be57dba2140f5ab071e7a"
    sha256                               arm64_sonoma:  "0cfd5e3130eb003fbd93c80f6e95c0ce320f9587b60c7b6432058d8fe0a33fe5"
    sha256                               sonoma:        "110930120d597424baf52e2b15f7a82b76c8b792d96dca9f6acc818eaaf97079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7abee4b8b78412bab13d747b14e38aec267c41fec55b9648b64bf2ae0386fc09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f19066f5c13ade30bb33a6876f11b5f88294ef0672e19b3f1c6cd9b162cac2b"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c@78"
  depends_on "libpng"
  depends_on "lzlib"

  uses_from_macos "zlib"

  fails_with :gcc do
    version "7"
    cause "Requires C++17 filesystem"
  end

  # Fix build with Boost 1.89.0, pr ref: https://github.com/apngasm/apngasm/pull/111
  patch do
    url "https://github.com/apngasm/apngasm/commit/7bf77bdefd348c629f650e2a5102a26ab6bee7b8.patch?full_index=1"
    sha256 "cbb9d679c5d46424bb00962481903f12b8b0e943dfdc98910ad05af7c7dacf5b"
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
