class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/3.25.tar.gz"
  sha256 "c45afb6399e3f68036ddb641c6bf6f552bf332d5ab6be62f7e6c54eda05ceb77"
  license "Zlib"
  head "https://github.com/bulletphysics/bullet3.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "70c2517b16906464fba68e8c3467d6440e483e550f649402339bddf1bcaa87dd"
    sha256 cellar: :any,                 arm64_ventura:  "6cb9f0e3435ac577cdae63a3593693da7a2e93110e92691f9b43ab35282bfa5a"
    sha256 cellar: :any,                 arm64_monterey: "84fe44bad0dc14eb49e1cd40c6ef1545c05186aca4a5a7e5e485fdabc3751fe5"
    sha256 cellar: :any,                 arm64_big_sur:  "c786c28169f4f65cfb8c6183453a468386ec9f58dbfa45420510ebd272be1ecd"
    sha256 cellar: :any,                 sonoma:         "329d917b1c71b47a29f24fdf341a0deb6ce89a3d84b9c6233bde1b37bc0f61bb"
    sha256 cellar: :any,                 ventura:        "4bfaa654682214a65629e2d09f36944857fc67162fde4bbb67e7bce7b6ff10b6"
    sha256 cellar: :any,                 monterey:       "50eed1d7cd3dedb6c64970b2a729e0128cb18f20477c106676e18d7539764fda"
    sha256 cellar: :any,                 big_sur:        "89803317a3b1ca72df1f1473efd8d99bcb857f47c2c3adccc7b4cb3ffc2fe406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3670bbfd66cfd61791baf1e268c42baab46191b1b8e11392d18d6f34c8b1875"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "python" => :build

  def install
    # C++11 for nullptr usage in examples. Can remove when fixed upstream.
    # Issue ref: https://github.com/bulletphysics/bullet3/pull/4243
    ENV.cxx11 if OS.linux?

    common_args = %w[
      -DBT_USE_EGL=ON
      -DBUILD_UNIT_TESTS=OFF
      -DINSTALL_EXTRA_LIBS=ON
      -DBULLET2_MULTITHREADING=ON
    ]

    double_args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{opt_lib}/bullet/double
      -DUSE_DOUBLE_PRECISION=ON
      -DBUILD_SHARED_LIBS=ON
    ]

    mkdir "builddbl" do
      system "cmake", "..", *double_args, *common_args
      system "make", "install"
    end
    dbllibs = lib.children
    (lib/"bullet/double").install dbllibs

    args = std_cmake_args + %W[
      -DBUILD_PYBULLET_NUMPY=ON
      -DCMAKE_INSTALL_RPATH=#{opt_lib}
    ]

    mkdir "build" do
      system "cmake", "..", *args, *common_args, "-DBUILD_SHARED_LIBS=OFF", "-DBUILD_PYBULLET=OFF"
      system "make", "install"

      system "make", "clean"

      system "cmake", "..", *args, *common_args, "-DBUILD_SHARED_LIBS=ON", "-DBUILD_PYBULLET=ON"
      system "make", "install"
    end

    # Install single-precision library symlinks into `lib/"bullet/single"` for consistency
    lib.each_child do |f|
      next if f == lib/"bullet"

      (lib/"bullet/single").install_symlink f
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "LinearMath/btPolarDecomposition.h"
      int main() {
        btMatrix3x3 I = btMatrix3x3::getIdentity();
        btMatrix3x3 u, h;
        polarDecompose(I, u, h);
        return 0;
      }
    EOS

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
  end
end
