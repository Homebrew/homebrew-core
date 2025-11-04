# Filename: cbo-stiefel.rb.template

class CboStiefel < Formula
  # 1. METADATA
  desc "A gradient free algorithm that optimises highly non-convex functions over Stiefel Manifolds (Orthogonal matrices of dimension n*k)"
  homepage "https://github.com/c0rmac/CBO-Stiefel/tree/main/cbo-stiefel"

  # These lines will be replaced by the build script (build_cbo_module.sh)
  url "https://github.com/c0rmac/CBO-Stiefel/releases/download/v1.0.0/cbo-stiefel_module-1.0.0-Source.tar.gz"
  version "1.0.0"
  sha256 "7699f9862989164aac7f2456ecf58930eac2f1eca2488af573ce4ccfbc95f3be"

  # 2. DEPENDENCIES
  depends_on "cmake" => :build
  depends_on "eigen"
  depends_on "pybind11"
  # Ensures the Homebrew installation finds and uses its own Python interpreter
  depends_on "python"

  # 3. INSTALLATION
  def install
    # Set up CMake arguments
    args = std_cmake_args
    # Assuming your CMakeLists.txt supports a flag to disable Python bindings
    args << "-DBUILD_PYTHON_BINDINGS=OFF"

    # Ensure CMake finds Homebrew's installed dependencies (only Eigen remains)
    ENV.prepend_path "CMAKE_PREFIX_PATH", Formula["eigen"].opt_share/"eigen3/cmake"

    # Configure the project
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"

    # CRUCIAL: Run the CMake install step to place C++ headers and libraries
    # Your CMakeLists.txt must define install(TARGETS...) for this to work.
    system "cmake", "--install", "build"
  end

  # 4. TEST BLOCK
  test do
    # Simple C++ test to confirm headers are accessible and library can be linked.
    (testpath/"test.cpp").write <<~EOS
      #include <cbo-stiefel/src/solvers/base_solver.h>
      #include <iostream>
      int main() {
        std::cout << "CBO-Stiefel C++ library loaded." << std::endl;
        return 0;
      }
    EOS

    # NOTE: This complex test may need adjustment based on your C++ install targets
    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test",
      "-I#{include}", "-L#{lib}", "-lcbo-stiefel_module" # Link against the installed library target
    system "./test"
  end
end