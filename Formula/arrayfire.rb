class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.8.1/arrayfire-full-3.8.1.tar.bz2"
  sha256 "13edaeb329826e7ca51b5db2d39b8dbdb9edffb6f5b88aef375e115443155668"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, big_sur:  "9869e0f31434835932fb93a6036b4d0bea62630b4392f076fafedda977ed5f8a"
    sha256 cellar: :any, catalina: "509d9c63cc8f3300f4cd026bcc09645474d17d0bfe0bc9d9ca7241996f1a6e6d"
    sha256 cellar: :any, mojave:   "da0132f5c4acb4d8e4b74a8f442175430ffc080a6a4ad8e0c3612a0bf92d1749"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "fftw"
  depends_on "freeimage"
  depends_on "openblas"

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
