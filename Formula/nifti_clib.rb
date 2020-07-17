class NiftiClib < Formula
  desc "C libraries for NIFTI support"
  homepage "https://github.com/NIFTI-Imaging/nifti_clib"
  url "https://github.com/leej3/nifti_clib/archive/v3.0.0.tar.gz"
  sha256 "fe6cb1076974df01844f3f4dab1aa844953b3bc1d679126c652975158573d03d"

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
      "-DBUILD_SHARED_LIBS=ON"
    system "make", "install"
  end

  test do
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "#{bin}/nifti_tool", "-help"
    system "#{bin}/nifti1_tool", "-help"
    system "#{bin}/nifti_stats", "-help"
  end
end
