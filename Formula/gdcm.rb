class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://github.com/malaterre/GDCM/archive/v3.0.3.tar.gz"
  sha256 "62d038c15454dd3f03f8c9d1bba9268ff15635527f0cb11a08f31a1010756cb7"

  bottle do
    sha256 "bc4aa24db86c1b37a5c1c7373fb11e0a65d3ef64504f0ff559a50ed6220ae882" => :catalina
    sha256 "acfda9b32bd0990ecb581056267259a1a9913fd306b5a6e0c3dab6773284749b" => :mojave
    sha256 "23a2d89084831eb4b48b557b97b4b17b47d6d1852cfbd3efbee32451a140b064" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "openjpeg"
  depends_on "openssl@1.1"
  depends_on "python"
  depends_on "vtk"

  def install
    ENV.cxx11

    xy = Language::Python.major_minor_version "python3"
    python_include = Utils.popen_read("python3 -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'").chomp
    python_executable = Utils.popen_read("python3 -c 'import sys;print(sys.executable)'").chomp

    args = std_cmake_args + %W[
      -GNinja
      -DGDCM_BUILD_APPLICATIONS=ON
      -DGDCM_BUILD_SHARED_LIBS=ON
      -DGDCM_BUILD_TESTING=OFF
      -DGDCM_BUILD_EXAMPLES=OFF
      -DGDCM_BUILD_DOCBOOK_MANPAGES=OFF
      -DGDCM_USE_VTK=ON
      -DGDCM_USE_SYSTEM_OPENJPEG=ON
      -DGDCM_USE_SYSTEM_OPENSSL=ON
      -DGDCM_WRAP_PYTHON=ON
      -DPYTHON_EXECUTABLE=#{python_executable}
      -DPYTHON_INCLUDE_DIR=#{python_include}
      -DGDCM_INSTALL_PYTHONMODULE_DIR=#{lib}/python#{xy}/site-packages
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DGDCM_NO_PYTHON_LIBS_LINKING=ON
    ]

    mkdir "build" do
      ENV.append "LDFLAGS", "-undefined dynamic_lookup"

      system "cmake", "..", *args
      system "ninja"
      system "ninja", "install"
    end
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

    system "python3", "-c", "import gdcm"
  end
end
