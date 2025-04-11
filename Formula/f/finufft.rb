class Finufft < Formula
  desc "Flatiron Institute Nonuniform Fast Fourier Transform"
  homepage "https://finufft.readthedocs.io/"
  url "https://github.com/flatironinstitute/finufft/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "0dac7f8f2648fbf5c448cf23a331766e29a7c87b86365d28efb1793b4b023ac1"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gcc" # for OpenMP support
  depends_on "libomp"

  def install
    # Check if MATLAB exists
    matlab_exists = !`which matlab`.empty?

    args = %W[
      -DFINUFFT_BUILD_TESTS=ON
      -DFINUFFT_BUILD_EXAMPLES=ON
      -DFINUFFT_BUILD_FORTRAN=ON
      -DCMAKE_C_COMPILER=#{ENV.cc}
      -DCMAKE_CXX_COMPILER=#{ENV.cxx}
      -DCMAKE_CXX_FLAGS='-std=c++17'
      -DFINUFFT_BUILD_MATLAB=#{matlab_exists ? "ON" : "OFF"}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"

    # Install test files to share directory after build but before install
    pkgshare.install "test"

    system "cmake", "--install", "build"

    # Ensure all headers are installed
    include.install "include/finufft.h"
    (include/"finufft").install Dir["include/finufft/*"]
  end

  test do
    # Write a minimal test program
    (testpath/"test.cpp").write <<~EOS
      #include <finufft.h>
      int main() {
        finufft_opts opts;
        finufft_default_opts(&opts);
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lfinufft",
           "-o", "test"
    system "./test"

    # Now reproduce the make test functionality
    # Copy test directory to testpath and set up results directory
    cp_r "#{HOMEBREW_PREFIX}/share/finufft/test/.", testpath
    (testpath/"results").mkpath

    # Find and compile all test programs
    Dir["#{HOMEBREW_PREFIX}/share/finufft/test/*.cpp"].each do |src|
      basename = File.basename(src, ".cpp")
      # Double precision version
      system ENV.cxx, "-std=c++17", "-I#{include}",
             src, "-L#{HOMEBREW_PREFIX}/lib",
             "-lfinufft", "-lfftw3",
             "-o", basename

      # Single precision version
      system ENV.cxx, "-std=c++17", "-DSINGLE", "-I#{include}",
             src, "-L#{HOMEBREW_PREFIX}/lib",
             "-lfinufft", "-lfftw3f",
             "-o", "#{basename}f"
    end

    # Run the tests
    ENV["OMP_NUM_THREADS"] = "4"
    system "./basicpassfail"
    system "./basicpassfailf"

    # Run the shell script tests
    system "./check_finufft.sh"
    system "./check_finufft.sh", "SINGLE"
  end
end
