class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://github.com/malaterre/GDCM/archive/v3.0.21.tar.gz"
  sha256 "7c456162a2de722cc90e3bdc46900302b1c367540a7131268d7bfd2a819cb5ed"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "3bf3bf38b2a89d79576b5cf2bdd8f68ad72047fb9029d4c6e69e5af41af74706"
    sha256 arm64_monterey: "01dc34dbaadaed73e79c49a30c4d402c88f971285c88d499477853c70ab8a01a"
    sha256 arm64_big_sur:  "040c819850b7d276ce72e0ea7fc4544379a286660c0b39adde3c362019bc70d2"
    sha256 ventura:        "bb5d8f691405c5067deb7176a10d380a9e12906b80ba00d07a0a988f1ceb091c"
    sha256 monterey:       "2cffcbfc838b33f99c8bf97a22e9f5880310a2d3e30709b363cade4b7554df2c"
    sha256 big_sur:        "03823f279d09ec76c9e24c14f20435219aefc6839bcb06e469f0ae5a4d69a348"
    sha256 x86_64_linux:   "7610b3e286220a7a88e177d3b970c69ae83da1464fbbeec31f48f9fa1b478b50"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "openjpeg"
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" # for libuuid
  end

  fails_with gcc: "5"

  def python3
    which("python3.11")
  end

  def install
    python_include =
      Utils.safe_popen_read(python3, "-c", "from distutils import sysconfig;print(sysconfig.get_python_inc(True))")
           .chomp

    prefix_site_packages = prefix/Language::Python.site_packages(python3)
    args = [
      "-DCMAKE_CXX_STANDARD=11",
      "-DGDCM_BUILD_APPLICATIONS=ON",
      "-DGDCM_BUILD_SHARED_LIBS=ON",
      "-DGDCM_BUILD_TESTING=OFF",
      "-DGDCM_BUILD_EXAMPLES=OFF",
      "-DGDCM_BUILD_DOCBOOK_MANPAGES=OFF",
      "-DGDCM_USE_VTK=OFF", # No VTK 9 support: https://sourceforge.net/p/gdcm/bugs/509/
      "-DGDCM_USE_SYSTEM_EXPAT=ON",
      "-DGDCM_USE_SYSTEM_ZLIB=ON",
      "-DGDCM_USE_SYSTEM_UUID=ON",
      "-DGDCM_USE_SYSTEM_OPENJPEG=ON",
      "-DGDCM_USE_SYSTEM_OPENSSL=ON",
      "-DGDCM_WRAP_PYTHON=ON",
      "-DPYTHON_EXECUTABLE=#{python3}",
      "-DPYTHON_INCLUDE_DIR=#{python_include}",
      "-DGDCM_INSTALL_PYTHONMODULE_DIR=#{prefix_site_packages}",
      "-DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: prefix_site_packages)}",
      "-DGDCM_NO_PYTHON_LIBS_LINKING=#{OS.mac?}",
    ]
    if OS.mac?
      %w[EXE SHARED MODULE].each do |type|
        args << "-DCMAKE_#{type}_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup -liconv"
      end
    end

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cxx").write <<~EOS
      #include "gdcmReader.h"
      int main(int, char *[])
      {
        gdcm::Reader reader;
        reader.SetFileName("file.dcm");
      }
    EOS

    system ENV.cxx, "-std=c++11", "-isystem", "#{include}/gdcm-3.0", "-o", "test.cxx.o", "-c", "test.cxx"
    system ENV.cxx, "-std=c++11", "test.cxx.o", "-o", "test", "-L#{lib}", "-lgdcmDSED"
    system "./test"

    system python3, "-c", "import gdcm"
  end
end
