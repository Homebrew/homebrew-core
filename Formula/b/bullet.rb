class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/refs/tags/3.25.tar.gz"
  sha256 "c45afb6399e3f68036ddb641c6bf6f552bf332d5ab6be62f7e6c54eda05ceb77"
  license "Zlib"
  head "https://github.com/bulletphysics/bullet3.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sequoia: "97aeccf39592bcf03e7dd07b5339ec03b11345137a8e0872288bb8deff702c6b"
    sha256 cellar: :any,                 arm64_sonoma:  "367a1f5cdab325d50b7c6ef7b46782d578bb7c0f0dac9f233e2b1779c91feb4a"
    sha256 cellar: :any,                 arm64_ventura: "c69182f86bc7b5a3407cbee2b2fae2ed2a4959b766d1fb22408d3acf30e1400c"
    sha256 cellar: :any,                 sonoma:        "6e4a848bf66030dac19ff6dd0677df1ed6f9d46e55d3a6ed3ce14ba63a97404f"
    sha256 cellar: :any,                 ventura:       "c039c3d01c76f8871b82a55ecc4ab41598e14fae12819f74f9544d2b80a1a904"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81e0edf216d5e0d24934cbb44c7becb7a3c1b7bef8d220496b7e4d5f0b754148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a755ae748428c5dfff82e6a4d57b81fbb4759fd494837d07b4535c0e88f3a16"
  end

  depends_on "cmake" => :build
  depends_on "numpy" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test]

  def python3
    "python3.13"
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
