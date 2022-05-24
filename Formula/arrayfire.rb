class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.8.1/arrayfire-full-3.8.1.tar.bz2"
  sha256 "13edaeb329826e7ca51b5db2d39b8dbdb9edffb6f5b88aef375e115443155668"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c91188803bdb170202adc8fcc0b26294057e119e0bdefa1843ab158602ddd0b9"
    sha256 cellar: :any,                 arm64_big_sur:  "3b7d5567de48d187d18c4e5a12d7a292d0c4dfebb9e181222ef4030a9b7115fc"
    sha256 cellar: :any,                 monterey:       "2e28ca14205729d079b08b01eeb91d6c090d9c50caa7321a2fb7fa55a8bfd376"
    sha256 cellar: :any,                 big_sur:        "4b59cd0db04eaf807b459f872b4fe2e6401cc5c9ae3675bdafb7af52f742ca3e"
    sha256 cellar: :any,                 catalina:       "81f15373fb946ee09ed96d57731a07c06d85a522db953ed131b2de747f18fe0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a34242e438745f4309147b5b0adbc2440ee9d1292dbadc2b7dff2707eb61a217"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "fftw"
  depends_on "freeimage"
  depends_on "openblas"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # Fix for: `ArrayFire couldn't locate any backends.`
    if OS.mac?
      ENV.append "LDFLAGS", "-Wl,-rpath,@loader_path/#{Formula["fftw"].opt_lib.relative_path_from(lib)}"
      ENV.append "LDFLAGS", "-Wl,-rpath,@loader_path/#{Formula["openblas"].opt_lib.relative_path_from(lib)}"
      ENV.append "LDFLAGS", "-Wl,-rpath,@loader_path/#{(HOMEBREW_PREFIX/"lib").relative_path_from(lib)}"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DAF_BUILD_CUDA=OFF",
                    "-DAF_COMPUTE_LIBRARY=FFTW/LAPACK/BLAS",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/helloworld/helloworld.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laf", "-lafcpu", "-o", "test"
    assert_match "ArrayFire v#{version}", shell_output("./test")
  end
end
