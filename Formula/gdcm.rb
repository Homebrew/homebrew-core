class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://github.com/malaterre/GDCM/archive/v3.0.8.tar.gz"
  sha256 "47b96be345b1611784f9e65fc39367c7450c9a1ef81c21f8acddfb6207098315"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "e5d409d8c7c2d3c9888b4666de72f72671a4c52e0b6e40bc28a48988221a9a64"
    sha256 big_sur:       "9e212eede12495c23aac2e76516dec184bddf3ec3056c3128fe5b72f74f5d93a"
    sha256 catalina:      "584352feb306fff666456a8c281292e1a73908b5eac6d78d87e3264ff87d5f62"
    sha256 mojave:        "eb192ec65565b2045d9cf3fc7c9ab1f5ef96573489a0739aa84c25a318c89669"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "openjpeg"
  depends_on "openssl@1.1"
  depends_on "python@3.9"
  depends_on "vtk@8.2"

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
