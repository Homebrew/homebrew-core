class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/6.2.2/libxc-6.2.2.tar.bz2"
  sha256 "ec292de621e819b03a37db1f7a7365a9eaf423e30e2fd4553e6336eca534cc29"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "4137ad3e56f47ffab7864f99478f77a8d48272e6695e4ea46caeaf8b367d4dbc"
    sha256 cellar: :any,                 arm64_sonoma:   "d3b7a181e48fbe340461e747e09de5b03463a42640ea7e3d17e70344e68a13fb"
    sha256 cellar: :any,                 arm64_ventura:  "76e117d24f61975699724c178dc4ca067b3ac7894fe44b2ccbecbac4896531e4"
    sha256 cellar: :any,                 arm64_monterey: "a17707ff2b6046f4b20246a3f4516d5c8dd025b42f1332b079d61c597e0d2acb"
    sha256 cellar: :any,                 sonoma:         "4c172504c169ec73171e917fac317d4893d812e60f720fef5a475f5d543bbd8a"
    sha256 cellar: :any,                 ventura:        "c549634c09e5a9f0688cf56a53923f257f465926fee68ff57486bab631d1b249"
    sha256 cellar: :any,                 monterey:       "cd6a9789100cbb16589d41114a37b58f70deb902bdbb5cdd4294d057fb75f76b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab8fde994c4cfb4c5bfb6095d4845c11f6a9947800d52b642198575050ae6fa3"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "gcc" # for gfortran

  def install
    args = %w[
      -DENABLE_FORTRAN=ON
      -DDISABLE_KXC=OFF
      -DDISABLE_LXC=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Common test files for both cmake and plain
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <xc.h>
      int main()
      {
        int major, minor, micro;
        xc_version(&major, &minor, &micro);
        printf("%d.%d.%d", major, minor, micro);
      }
    EOS
    (testpath/"test.f90").write <<~EOS
      program lxctest
        use xc_f03_lib_m
      end program lxctest
    EOS
    # Simple cmake example
    (testpath / "CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.6)
      project(test_libxc LANGUAGES C Fortran)
      find_package(Libxc CONFIG REQUIRED)
      add_executable(test_c test.c)
      target_link_libraries(test_c PRIVATE Libxc::xc)
      add_executable(test_fortran test.f90)
      target_link_libraries(test_fortran PRIVATE Libxc::xcf03)
    EOS
    # Test cmake build
    system "cmake", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/test_c"
    system "./build/test_fortran"
    # Test compilers directly
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxc", "-o", "ctest", "-lm"
    system "./ctest"
    system "gfortran", "test.f90", "-L#{lib}", "-lxc", "-I#{include}",
                       "-o", "ftest"
    system "./ftest"
  end
end
