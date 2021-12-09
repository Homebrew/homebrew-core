class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/3.21.tar.gz"
  sha256 "49d1ee47aa8cbb0bc6bb459f0a4cfb9579b40e28f5c7d9a36c313e3031fb3965"
  license "Zlib"
  head "https://github.com/bulletphysics/bullet3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ed4d4e01d663fe04ff8e27f3f7bf8b85dbd0737c0bdc4cbdd1e397737b257f43"
    sha256 cellar: :any,                 arm64_big_sur:  "0922421129df15920cc29e38684f6b8ac6dd88fc275eb4afe77f2c244676d827"
    sha256 cellar: :any,                 monterey:       "7f94b5aa89d25a67477240fbc1d9791498cd6f947c54ec9d98542adcf737f092"
    sha256 cellar: :any,                 big_sur:        "4dea7d88d2f4e986caafaf55868e5f35148f5727b0c71b135f61001a7621da65"
    sha256 cellar: :any,                 catalina:       "38141da23a12028cd82b1932b1bf4571058ee690f4f2f248f20c7f0ef5a8e4ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99337f0a712e95589b277d350f50516eac5336653b586b3170d2e77e7633febc"
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
