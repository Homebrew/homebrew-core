class Bullet < Formula
  desc "Physics SDK"
  homepage "https://pybullet.org/"
  url "https://github.com/bulletphysics/bullet3/archive/refs/tags/3.25.tar.gz"
  sha256 "c45afb6399e3f68036ddb641c6bf6f552bf332d5ab6be62f7e6c54eda05ceb77"
  license "Zlib"
  compatibility_version 1
  head "https://github.com/bulletphysics/bullet3.git", branch: "master"

  bottle do
    rebuild 5
    sha256 cellar: :any, arm64_golden_gate: "c461c2ded66ee288ea1df87192f23570211f92e72cd4f80124194a27c446b3f7"
    sha256 cellar: :any, arm64_tahoe:       "405a0fc527245d26e417c75a10b70056497436c62c5607e56368272c702dae45"
    sha256 cellar: :any, arm64_sequoia:     "288b77ba8d42262bcdf224d709577e225717a4a6930874fe84009f98314d64a1"
    sha256 cellar: :any, arm64_linux:       "e679ad6f9ef75949490c7ac9597cd778c3e85712bcb31eb7f5ade137bd65c488"
    sha256 cellar: :any, x86_64_linux:      "32e84f29da00c6ce2e625f7e49a88faf2c858fba56d714b337a8449507f10a6e"
  end

  depends_on "cmake" => :build
  depends_on "numpy" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "python@3.15" => [:build, :test]

  deny_network_access!

  def install
    common_args = %w[
      -DBT_USE_EGL=ON
      -DBUILD_UNIT_TESTS=OFF
      -DINSTALL_EXTRA_LIBS=ON
      -DBULLET2_MULTITHREADING=ON
    ] + std_cmake_args(find_framework: "FIRST")

    # Workaround to build with CMake 4
    common_args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

    # Temporary fix for https://github.com/bulletphysics/bullet3/issues/4733
    common_args << "-D_CURRENT_OSX_VERSION=#{MacOS.full_version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build_double",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{loader_path}",
                    "-DUSE_DOUBLE_PRECISION=ON",
                    *common_args
    system "cmake", "--build", "build_double"
    system "cmake", "--install", "build_double"
    (lib/"bullet/double").install lib.children

    system "cmake", "-S", ".", "-B", "build_static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *common_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"

    python_version = Language::Python.major_minor_version python3
    python_prefix = if OS.mac?
      Formula["python@#{python_version}"].opt_frameworks/"Python.framework/Versions/#{python_version}"
    else
      formula_opt_prefix("python@#{python_version}")
    end
    prefix_site_packages = prefix/Language::Python.site_packages(python3)

    system "cmake", "-S", ".", "-B", "build_shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{loader_path};#{rpath(source: prefix_site_packages)}",
                    "-DBUILD_PYBULLET=ON",
                    "-DBUILD_PYBULLET_NUMPY=ON",
                    "-DPYTHON_EXECUTABLE=#{python3}",
                    "-DPYTHON_INCLUDE_DIR=#{python_prefix}/include/python#{python_version}",
                    "-DPYTHON_LIBRARY=#{python_prefix}/lib",
                    *common_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    # Install single-precision library symlinks into `lib/"bullet/single"` for consistency
    (lib/"bullet/single").install_symlink (lib.children - [lib/"bullet"])
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "LinearMath/btPolarDecomposition.h"
      int main() {
        btMatrix3x3 I = btMatrix3x3::getIdentity();
        btMatrix3x3 u, h;
        polarDecompose(I, u, h);
        return 0;
      }
    CPP

    cxx_lib = if OS.mac?
      "-lc++"
    else
      "-lstdc++"
    end

    # Test single-precision library
    system ENV.cc, "test.cpp", "-I#{include}/bullet", "-L#{lib}",
                   "-lLinearMath", cxx_lib, "-o", "test"
    system "./test"

    # Test double-precision library
    system ENV.cc, "test.cpp", "-I#{include}/bullet", "-L#{lib}/bullet/double",
                   "-lLinearMath", cxx_lib, "-o", "test"
    system "./test"

    system python3, "-c", <<~PYTHON
      import pybullet
      pybullet.connect(pybullet.DIRECT)
      pybullet.setGravity(0, 0, -10)
      pybullet.disconnect()
    PYTHON
  end
end
