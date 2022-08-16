class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://github.com/malaterre/GDCM/archive/v3.0.14.tar.gz"
  sha256 "12582a87a1f043ce77005590ef1060e92ad36ec07ccf132da49c59f857d413ee"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "a7dc4914a7cd884815177aefc9cc23444bc1efb8a4584cacd7950dc02509e8ad"
    sha256 arm64_big_sur:  "a3517e5d4b4ba0c89c60456fa1feb5b33d5f11eae0c5c2d0bdd9ba9995e7d663"
    sha256 monterey:       "76103bde1931e4a7a2b80ea41a9049eeb7d3a5013f7097ea429517137fcf620e"
    sha256 big_sur:        "58fb14e9d89ae2ffd8adcffeb56edc2a6c94fdd9ea804f5939946e764994c192"
    sha256 catalina:       "5828042a4147b3e6b8b54cd3c39d15296936dd2d976f49e030baea8c74d82014"
    sha256 x86_64_linux:   "ebfad3232ed2b2ac02b3ec0dcdbbcd2be320f2834e76ca95186093215eed28cc"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "openjpeg"
  depends_on "openssl@1.1"
  depends_on "python@3.9"
  depends_on "vtk@8.2"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def python3
    which("python3.9")
  end

  def install
    ENV.cxx11

    python_include =
      Utils.safe_popen_read(python3, "-c", "from distutils import sysconfig;print(sysconfig.get_python_inc(True))")
           .chomp
    python_executable = Utils.safe_popen_read(python3, "-c", "import sys;print(sys.executable)").chomp

    args = %W[
      -GNinja
      -DGDCM_BUILD_APPLICATIONS=ON
      -DGDCM_BUILD_SHARED_LIBS=ON
      -DGDCM_BUILD_TESTING=OFF
      -DGDCM_BUILD_EXAMPLES=OFF
      -DGDCM_BUILD_DOCBOOK_MANPAGES=OFF
      -DGDCM_USE_VTK=ON
      -DGDCM_USE_SYSTEM_EXPAT=ON
      -DGDCM_USE_SYSTEM_ZLIB=ON
      -DGDCM_USE_SYSTEM_UUID=ON
      -DGDCM_USE_SYSTEM_OPENJPEG=ON
      -DGDCM_USE_SYSTEM_OPENSSL=ON
      -DGDCM_WRAP_PYTHON=ON
      -DPYTHON_EXECUTABLE=#{python_executable}
      -DPYTHON_INCLUDE_DIR=#{python_include}
      -DGDCM_INSTALL_PYTHONMODULE_DIR=#{prefix/Language::Python.site_packages(python3)}
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DGDCM_NO_PYTHON_LIBS_LINKING=ON
    ]

    ENV.append "LDFLAGS", "-undefined dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
