class NiftiClib < Formula
  desc "C libraries for NIFTI support"
  homepage "https://github.com/NIFTI-Imaging/nifti_clib"
  url "https://github.com/NIFTI-Imaging/nifti_clib/archive/v3.0.1.tar.gz"
  sha256 "868b611b5f8a3a73809436c9072db50db4975615905f0bd5fb7b1432e6d24b37"
  license :public_domain

  depends_on "cmake" => :build
  depends_on "help2man" => :build
  depends_on "make" => :build
  uses_from_macos "zlib"

  def install
    # Install static libraries
    system "cmake", ".",
      "-DCMAKE_BUILD_TYPE=RELWITHDEBINFO",
      "-DCMAKE_INSTALL_PREFIX=#{prefix}",
      "-DNIFTI_INSTALL_MAN_DIR=#{man}",
      "-DDOWNLOAD_TEST_DATA=OFF",
      "-DTEST_INSTALL=OFF"
    system "make"
    system "cmake",
      "-DCOMPONENT=RuntimeLibraries",
      "-P", "cmake_install.cmake",
      "install"

    # Install shared object libraries, and all other components of build
    system "cmake", ".",
      "-DNIFTI_INSTALL_NO_DOCS=FALSE",
      "-DBUILD_SHARED_LIBS=ON"
    system "make", "install"
  end

  test do
    # Run basic example of using cmake to link against libnifticdf as a downstream
    (testpath/"test.c").write <<~EOS
      #include <nifticdf.h>
      int main()
      {
        double input= 7.0;
        const double output = alnrel(&input);
        return (output > 0.0) ? EXIT_SUCCESS: EXIT_FAILURE ;
      }
    EOS
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.10.2)
      project(demo LANGUAGES C)
      find_package(NIFTI REQUIRED)
      add_executable(demo_exe test.c)
      target_link_libraries(demo_exe PRIVATE NIFTI::nifticdf)
    EOS

    system "cmake", "."
    system "make"
    system "./demo_exe"
  end
end
