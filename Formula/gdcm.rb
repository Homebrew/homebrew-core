class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://downloads.sourceforge.net/project/gdcm/gdcm%202.x/GDCM%202.8.4/gdcm-2.8.4.tar.gz"
  sha256 "8f480d0a9b0b331f2e83dcc9cdb3d957f10eb32ee4db90fc1c153172dcb45587"
  revision 3

  bottle do
    sha256 "a79975c2347ea83bc1ea9eb081c2006fbe518ca6ed42bcd7d37e5c53da6a13ec" => :high_sierra
    sha256 "a3421a33458e622259bdb389052cde74f9a6b24f89799e08ae0df0ffa549bad8" => :sierra
    sha256 "b59018c43721c0892b60e52b26c2d5a2d2d63087ecd34dc4e0ef72bf17d63ac4" => :el_capitan
  end

  option "without-python@2", "Build without python2 support"

  deprecated_option "with-python3" => "with-python"
  deprecated_option "without-python" => "without-python@2"

  depends_on "python@2" => :recommended if MacOS.version <= :snow_leopard
  depends_on "python" => :optional
  depends_on "swig" => :build if build.with?("python") || build.with?("python@2")

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openjpeg"
  depends_on "openssl"

  needs :cxx11

  def install
    ENV.cxx11

    common_args = std_cmake_args + %w[
      -DGDCM_BUILD_APPLICATIONS=ON
      -DGDCM_BUILD_SHARED_LIBS=ON
      -DGDCM_BUILD_TESTING=OFF
      -DGDCM_BUILD_EXAMPLES=OFF
      -DGDCM_BUILD_DOCBOOK_MANPAGES=OFF
      -DGDCM_USE_VTK=OFF
      -DGDCM_USE_SYSTEM_OPENJPEG=ON
      -DGDCM_USE_SYSTEM_OPENSSL=ON
    ]

    mkdir "build" do
      if build.without?("python") && build.without?("python@2")
        system "cmake", "..", *common_args
        system "make", "install"
      else
        ENV.append "LDFLAGS", "-undefined dynamic_lookup"

        Language::Python.each_python(build) do |python, py_version|
          python_include = Utils.popen_read("#{python} -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'").chomp
          args = common_args + %W[
            -DGDCM_WRAP_PYTHON=ON
            -DPYTHON_EXECUTABLE=#{python}
            -DPYTHON_INCLUDE_DIR=#{python_include}
            -DGDCM_INSTALL_PYTHONMODULE_DIR=#{lib}/python#{py_version}/site-packages
            -DCMAKE_INSTALL_RPATH=#{lib}
            -DGDCM_NO_PYTHON_LIBS_LINKING=ON
          ]

          system "cmake", "..", *args
          system "make", "install"
        end
      end
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

    system ENV.cxx, "-isystem", "#{include}/gdcm-2.8", "-o", "test.cxx.o", "-c", "test.cxx"
    system ENV.cxx, "test.cxx.o", "-o", "test", "-L#{lib}", "-lgdcmDSED"
    system "./test"

    Language::Python.each_python(build) do |python, _py_version|
      system python, "-c", "import gdcm"
    end
  end
end
