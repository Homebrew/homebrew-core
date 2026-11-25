class Apngasm < Formula
  desc "Next generation of apngasm, the APNG assembler"
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/refs/tags/3.1.10.tar.gz"
  sha256 "8171e2c1d37ab231a2061320cb1e5d15cee37642e3ce78e8ab0b8dfc45b80f6c"
  license "Zlib"
  revision 22
  head "https://github.com/apngasm/apngasm.git", branch: "master"

  bottle do
    rebuild 1
    manifest_sha256 "f3f25e97a75ef3e85c1906c1af35936ae75193776580fef9e633a8a700f91479"
    sha256 cellar: :any, arm64_golden_gate: "75b1327544e974d85649c29f0459eac6121f140741b07af0d6bd4c2082cf243a"
    sha256 cellar: :any, arm64_tahoe:       "cad720aa3a4ebf3e2daf37a133b3210d9f93acf077eb83942c8667415e8c43d2"
    sha256 cellar: :any, arm64_sequoia:     "c725e8e680b67caee6618cfcc39344fbc78d85fe7e766599ba7b708ac989bb57"
    sha256 cellar: :any, arm64_linux:       "ae3457772e3ad32de6dfd7c1c6566dd011434762073025d02e825563227a3cd8"
    sha256 cellar: :any, x86_64_linux:      "83682c2d412d224f02281b2b7ac9d0d724f696a68075c70ec8d3b0b30bf7b11d"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c@79"
  depends_on "libpng"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :gcc do
    version "7"
    cause "Requires C++17 filesystem"
  end

  # Fix build with Boost 1.89.0, pr ref: https://github.com/apngasm/apngasm/pull/111
  patch do
    url "https://github.com/apngasm/apngasm/commit/7bf77bdefd348c629f650e2a5102a26ab6bee7b8.patch?full_index=1"
    sha256 "cbb9d679c5d46424bb00962481903f12b8b0e943dfdc98910ad05af7c7dacf5b"
    type :unofficial
    resolves "https://github.com/apngasm/apngasm/pull/111"
  end

  deny_network_access!

  def install
    inreplace "cli/CMakeLists.txt", "${CMAKE_INSTALL_PREFIX}/man/man1",
                                    "${CMAKE_INSTALL_PREFIX}/share/man/man1"
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
