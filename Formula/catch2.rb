class Catch2 < Formula
  desc "A modern, C++-native, header-only, test framework for unit-tests, TDD and BDD - using C++11, C++14, C++17 and later (or C++03 on the Catch1.x branch)"
  homepage "https://discord.gg/4CWS9zD"
  url "https://github.com/catchorg/Catch2/archive/v2.5.0.tar.gz"
  version "2.5.0"
  sha256 "720c84d18f4dc9eb23379941df2054e7bcd5ff9c215e4d620f8533a130d128ae"
  head "https://github.com/catchorg/Catch2.git"
  depends_on "cmake" => :build

  def install
    inreplace "CMakeLists.txt", "{CMAKE_INSTALL_LIBDIR}/cmake", "{CMAKE_INSTALL_DATAROOTDIR}/cmake"
    system "cmake", "-Bbuild", "-H.", "-DBUILD_TESTING=OFF", *std_cmake_args
    system "cmake", "--build", "build", "--target", "install"
  end

end
