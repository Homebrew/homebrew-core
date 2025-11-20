class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/refs/tags/3.25.tar.gz"
  sha256 "c45afb6399e3f68036ddb641c6bf6f552bf332d5ab6be62f7e6c54eda05ceb77"
  license "Zlib"
  head "https://github.com/bulletphysics/bullet3.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_tahoe:   "87c1a6671e6825d2886bd6025091c80f3633033cb1f61bfb343512e7aacfd346"
    sha256 cellar: :any,                 arm64_sequoia: "16117f81a0c3c9e22cbdc21ebf7926bb39d29ad29bde9d84fbfad0b3b3cb1d68"
    sha256 cellar: :any,                 arm64_sonoma:  "290642f55b724eecb80aadd93a11a3faec1f6768db05412c4b6f21b5fc274cd3"
    sha256 cellar: :any,                 sonoma:        "354ff9e050f7c14b6f25ee2aaa865a2949538da6fc017c5f0e688639fa46f9e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fba99fe645c8290925e3a0dc6bdb8059e799b045de00c67cc0e67563bbdc33e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c9c0d8ab57375f2ffedb24fdfb000e4d52c96d3e948a4c5ebd986ad32e7ed70"
  end

  depends_on "cmake" => :build
  depends_on "numpy" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]

  def python3
    "python3.14"
  end

  def install
    # C++11 for nullptr usage in examples. Can remove when fixed upstream.
    # Issue ref: https://github.com/bulletphysics/bullet3/pull/4243
    ENV.cxx11 if OS.linux?

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
      Formula["python@#{python_version}"].opt_prefix
    end
    prefix_site_packages = prefix/Language::Python.site_packages(python3)

    system "cmake", "-S", ".", "-B", "build_shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{loader_path};#{rpath(source: prefix_site_packages)}",
                    "-DBUILD_PYBULLET=ON",
                    "-DBUILD_PYBULLET_NUMPY=ON",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
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
