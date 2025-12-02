class Clblas < Formula
  desc "Library containing BLAS functions written in OpenCL"
  homepage "https://github.com/clMathLibraries/clBLAS"
  url "https://github.com/clMathLibraries/clBLAS/archive/refs/tags/v2.12.tar.gz"
  sha256 "7269c7cb06a43c5e96772010eba032e6d54e72a3abff41f16d765a5e524297a9"
  license "Apache-2.0"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e6c3905b2128cd5fece2722262321cf7b446cb8119cc0c96f33e87a0e534a9d1"
    sha256 cellar: :any,                 arm64_sequoia:  "e01b9a3b09dc996c6feb5b474e99f463b4079417aa0c24c69d5ace2cb896b036"
    sha256 cellar: :any,                 arm64_sonoma:   "932e8b3b551e5d7e9bd274802aed00a7de5844a2fa3ead6b52647ffb7e2bdbed"
    sha256 cellar: :any,                 arm64_ventura:  "ddd0d6b3d160284e87fee5d6cbb6585632cd24842c1f26954205acb665e3c74a"
    sha256 cellar: :any,                 arm64_monterey: "ec2838495fac090d05c5eb2e2f5cb8fd3640bb238fc068459900e50cc7f28674"
    sha256 cellar: :any,                 arm64_big_sur:  "8ade8c33c4231863fb5ebda26cd90cd1e1b5f30193c9b7bb113939e2c588c9e9"
    sha256 cellar: :any,                 sonoma:         "07b22046dd5a9005ac31e41f688afd50aea6284d716ec67ab304d587d0f40f9e"
    sha256 cellar: :any,                 ventura:        "d8bc99eb36031d7e6f662b40b2d8ef98a1d60fe414959c2ec5f23c590ebcf353"
    sha256 cellar: :any,                 monterey:       "2be6e0730bf2740496eb4b90b90077ce65185ab8fc1c0714edb8ea834904a8ec"
    sha256 cellar: :any,                 big_sur:        "3f4f8ceae96d4b24049e7b81e89f7bc5785bcd7968bf5378fb54cafd259b6d92"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b645eb13199f77329df60710febfdbf4ca896fab88df65e3c03b2c4e221fc675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afc8e13fe7b5d465840eac248a461975d7fd33b89ba74a238cb743c1ac6c7c1f"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "opencl-headers" => [:build, :test]
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  # Fix missing stdlib.h includes.
  # PR ref: https://github.com/clMathLibraries/clBLAS/pull/360
  patch do
    url "https://github.com/clMathLibraries/clBLAS/commit/68ce5f0b824d7cf9d71b09bb235cf219defcc7b4.patch?full_index=1"
    sha256 "df5dc87e9ae543a043608cf790d01b985627b5b6355356c860cfd45a47ba2c36"
  end

  def install
    # Workaround for CMake 4 and CMP0048 as project looks unmaintained.
    # Can consider deprecating if bandicoot migrates to alternative like CLBlast:
    # https://gitlab.com/bandicoot-lib/bandicoot-code/-/issues/34
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
    version_str = "#{version.major.to_i}.#{version.minor.to_i}.#{version.patch.to_i}"
    inreplace "src/CMakeLists.txt", "project(clBLAS C CXX)",
                                    "project(clBLAS VERSION #{version_str} LANGUAGES C CXX)"

    system "cmake", "-S", "src", "-B", "build",
                    "-DBUILD_CLIENT=OFF",
                    "-DBUILD_KTEST=OFF",
                    "-DBUILD_TEST=OFF",
                    "-DCMAKE_MACOSX_RPATH:BOOL=ON",
                    "-DPYTHON_EXECUTABLE=#{which("python3")}",
                    "-DSUFFIX_LIB:STRING=",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "src/samples/example_srot.c"
  end

  test do
    # We do not run the test, as it fails on CI machines
    # ("clGetDeviceIDs() failed with -1")
    opencl_lib = OS.mac? ? ["-framework", "OpenCL"] : ["-lOpenCL"]
    system ENV.cc, pkgshare/"example_srot.c", "-I#{include}", "-L#{lib}",
                   "-lclBLAS", *opencl_lib, "-Wno-implicit-function-declaration"
  end
end
