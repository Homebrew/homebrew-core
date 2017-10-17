class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://downloads.sourceforge.net/project/gdcm/gdcm%202.x/GDCM%202.8.2/gdcm-2.8.2.tar.gz"
  sha256 "5462c7859e01e5d5d0fb86a19a6c775484a6c44abd8545ea71180d4c41bf0f89"
  revision 2

  bottle do
    sha256 "cb5c0931aa500ba666567ca1bc8fa0490b2b77fa25c4b4e0c40dbb26e76c4e23" => :high_sierra
    sha256 "5eecece5665b36dc5dfe0e90fc6fd9367df6f3749aeeb5e91300758bd0747975" => :sierra
    sha256 "efdb9b6ebd68e3d8203ff5da8f0c4c4e49aa18f87cd0fd2b28ccbc54713bf9d7" => :el_capitan
  end

  option "without-python", "Build without python2 support"

  depends_on :python3 => :optional
  depends_on "swig" => :build if build.with?("python") || build.with?("python3")

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "vtk"

  needs :cxx11

  def install
    ENV.cxx11

    common_args = std_cmake_args + %w[
      -DGDCM_BUILD_APPLICATIONS=ON
      -DGDCM_BUILD_SHARED_LIBS=ON
      -DGDCM_BUILD_TESTING=OFF
      -DGDCM_BUILD_EXAMPLES=OFF
      -DGDCM_BUILD_DOCBOOK_MANPAGES=OFF
      -DGDCM_USE_VTK=ON
      -DGDCM_USE_SYSTEM_OPENSSL=ON
    ]

    mkdir "build" do
      if build.without?("python") && build.without?("python3")
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
    (testpath/"test.cxx").write <<-EOS
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
