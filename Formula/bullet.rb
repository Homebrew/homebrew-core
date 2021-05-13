class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/3.17.tar.gz"
  sha256 "baa642c906576d4d98d041d0acb80d85dd6eff6e3c16a009b1abf1ccd2bc0a61"
  license "Zlib"
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fe699b09f7b1015fb07fef9aaf3bb5865baaa055b3cb59b7ebca307f15de350d"
    sha256 cellar: :any, big_sur:       "b27a9a26227f831ca70d7272475f06fe92e9a1017331e086dd1b84754a1c1af8"
    sha256 cellar: :any, catalina:      "cad56eb211080988162e997c2480c012c4489549e5137e4bd39b99238ec317d0"
    sha256 cellar: :any, mojave:        "20b56c89ba98e751bb9d72278e0e4dbd090dba00e16d715ccdfab18d3419e70d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

  def install
    common_args = %w[
      -DBT_USE_EGL=ON
      -DBUILD_UNIT_TESTS=OFF
      -DINSTALL_EXTRA_LIBS=ON
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

    cxx_lib = "-lc++"
    on_linux do
      cxx_lib = "-lstdc++"
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
