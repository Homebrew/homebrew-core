class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/3.24.tar.gz"
  sha256 "6b1e987d6f8156fa8a6468652f4eaad17b3e11252c9870359e5bca693e35780b"
  license "Zlib"
  head "https://github.com/bulletphysics/bullet3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "496fb748084f2ac94dbaf62899878477bd3fda1e6a38305f4ebf1263fbf92502"
    sha256 cellar: :any,                 arm64_monterey: "e62ed2decd835f7a0170558ff9823e1cd409af8718f171e909ba1d026b5b1857"
    sha256 cellar: :any,                 arm64_big_sur:  "791078c5f49a76ab5ecfb1c0dec290ea4ba048c578d7fe49deee1ae2c108d9ee"
    sha256 cellar: :any,                 ventura:        "158f3b0558793ed9b120eda1803fd5365cff51a65a1032a0ba41c897ced5e493"
    sha256 cellar: :any,                 monterey:       "4f025cbf5fb191f35fdfa59c663146265c4ad5789238e480b71f3422013aed72"
    sha256 cellar: :any,                 big_sur:        "e53efaacaf22922dbd1280786f5d75b670a765ea105f9c6cc706aa0f0fdd3861"
    sha256 cellar: :any,                 catalina:       "0d0863190a55bef157fb7955a4f2c9618ebae828f3661bf6c4d9ac7c5676d14a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec9a230902ea3638a673b810a67a00f0aa5be9b577a4a8947d8bed8519fb33b5"
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
