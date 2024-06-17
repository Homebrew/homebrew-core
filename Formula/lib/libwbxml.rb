class Libwbxml < Formula
  desc "Library and tools to parse and encode WBXML documents"
  homepage "https://github.com/libwbxml/libwbxml"
  url "https://github.com/libwbxml/libwbxml/archive/refs/tags/libwbxml-0.11.9.tar.gz"
  sha256 "704029f7745abfd58e26b54f15ce7de0d801048a9a359a7e9967f8346baeff3f"
  license "LGPL-2.1-or-later"
  head "https://github.com/libwbxml/libwbxml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d97b5597a9692c27d9a810ca628a2febbe1b95c20276021765bf9b3b7258189e"
    sha256 cellar: :any,                 arm64_ventura:  "fef6a0c53128442d71e20c6a7c1b1ffab1c649de54939f0a708d12369a00665a"
    sha256 cellar: :any,                 arm64_monterey: "2c9277ebb11f3c72c3cd5db7f4e9425d1cf9c6267215a2d1b268c0bb2f2a45bb"
    sha256 cellar: :any,                 sonoma:         "7bcac3ac4be1a36e9a83e83814bcdbf8c9174250e553f4f363e76adb1d98bd6d"
    sha256 cellar: :any,                 ventura:        "001104686da1ab293a681294f72fbda96325925c6e4f955ef04346490a8213da"
    sha256 cellar: :any,                 monterey:       "ad0d34f3717c82221243b057e8203b0e7b25c966ccdd86a1bce228696ba4bdaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6c0ce836f82ddc2db06a65d83bbf37b3d207c3d5f6157f73c59a434a492bb5c"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "wget"

  uses_from_macos "expat"

  def install
    # Sandbox fix:
    # Install in Cellar & then automatically symlink into top-level Module path
    inreplace "cmake/CMakeLists.txt", "${CMAKE_ROOT}/Modules/",
                                      "#{share}/cmake/Modules"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DBUILD_DOCUMENTATION=ON",
                            "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end
end
