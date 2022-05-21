class Ecbuild < Formula
  desc "CMake-based build system that eases the managing of building ECMWF software"
  homepage "https://ecbuild.readthedocs.io"
  url "https://github.com/ecmwf/ecbuild/archive/refs/tags/3.6.5.tar.gz"
  sha256 "98bff3d3c269f973f4bfbe29b4de834cd1d43f15b1c8d1941ee2bfe15e3d4f7f"
  license "Apache-2.0"

  depends_on "cmake"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "ctest", "-V"
      system "make", "install"
    end
  end

  test do
    # check that we can extract the version
    version_out = shell_output("#{bin}/ecbuild --version")
    assert_match version.to_s, version_out

    # create a small sample CMake project that uses ecbuild features
    (testpath/"src/CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.11 FATAL_ERROR)
      find_package(ecbuild REQUIRED)
      project(test_ecbuild_install VERSION 0.1.0 LANGUAGES NONE)
      ecbuild_add_option(FEATURE TEST_A DEFAULT OFF)
      if(HAVE_TEST_A)
        message(STATUS "TEST_A ON")
      else()
        message(STATUS "TEST_A OFF")
      endif()
    EOS

    default_output = shell_output("#{bin}/ecbuild -Wno-dev ./src")
    assert_match "TEST_A OFF", default_output
    rm "CMakeCache.txt"

    on_output = shell_output("#{bin}/ecbuild -Wno-dev ./src -DENABLE_TEST_A=ON")
    assert_match "TEST_A ON", on_output
    rm "CMakeCache.txt"

    off_output = shell_output("#{bin}/ecbuild -Wno-dev ./src -DENABLE_TEST_A=OFF")
    assert_match "TEST_A OFF", off_output
  end
end
