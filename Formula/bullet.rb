class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/3.24.tar.gz"
  sha256 "6b1e987d6f8156fa8a6468652f4eaad17b3e11252c9870359e5bca693e35780b"
  license "Zlib"
  head "https://github.com/bulletphysics/bullet3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "53c8070433e550cc819f1821088eeb3f17d65ae12ebc72b1d20be3772ff796ca"
    sha256 cellar: :any,                 arm64_big_sur:  "ce667cbcd3b96f3e9da37937bafa0e7bc053e7a15bde05e5b0f3a11191abbef1"
    sha256 cellar: :any,                 monterey:       "b4649dd529582a11585e7a8dcd5cc31dc2f505b6afad293f072d84153e8daca6"
    sha256 cellar: :any,                 big_sur:        "29060161f27a703aaedbeff2a311506345369251eb65cf505ff98afdd02ca9be"
    sha256 cellar: :any,                 catalina:       "10da86e16ca68c1dd5bec523f49f77593938b8d2a19fb41c8ed6e45a06781c34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54c825fba5694d0d1cc538f1f9333e6602457059371b4573cf554ded7e464d34"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build

  def install
    # C++11 for nullptr usage in examples. Can remove when fixed upstream.
    # Issue ref: https://github.com/bulletphysics/bullet3/pull/4243
    ENV.cxx11 if OS.linux?

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
