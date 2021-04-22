class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://github.com/malaterre/GDCM/archive/v3.0.9.tar.gz"
  sha256 "fcfc50ea8809bd4a173550c7d7bb4f8722ae0781fbf17240ce84a04e90af0e9b"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "87c8a3362d3784d43959aaf3b165e6e76f12d973218e03cdcee828cf90ee1487"
    sha256 big_sur:       "8e441a9aa21a943c91ef545607f22a2b893d32ceea0405a227477011d9d8cbbe"
    sha256 catalina:      "0711caa5fad5624b41ac9f923ed6d1ac0510695fedaee7146233625b38fb0f20"
    sha256 mojave:        "529d7a857599247949f3dafc1bddf73bfe76d2672bfefd5d1604dfce359cc81c"
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

  def install
    ENV.cxx11

    python3 = Formula["python@3.9"].opt_bin/"python3"
    xy = Language::Python.major_minor_version python3
    python_include =
      Utils.safe_popen_read(python3, "-c", "from distutils import sysconfig;print(sysconfig.get_python_inc(True))")
           .chomp
    python_executable = Utils.safe_popen_read(python3, "-c", "import sys;print(sys.executable)").chomp

    args = std_cmake_args + %W[
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
      -DGDCM_INSTALL_PYTHONMODULE_DIR=#{lib}/python#{xy}/site-packages
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DGDCM_NO_PYTHON_LIBS_LINKING=ON
    ]

    mkdir "build" do
      on_macos do
        ENV.append "LDFLAGS", "-undefined dynamic_lookup"
      end

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

    system Formula["python@3.9"].opt_bin/"python3", "-c", "import gdcm"
  end
end
