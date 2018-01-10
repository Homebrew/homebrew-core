class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://downloads.sourceforge.net/project/gdcm/gdcm%202.x/GDCM%202.8.4/gdcm-2.8.4.tar.gz"
  sha256 "8f480d0a9b0b331f2e83dcc9cdb3d957f10eb32ee4db90fc1c153172dcb45587"
  revision 2

  bottle do
    sha256 "7ca91961ffb0f74e9f055ece921101a23621c49a3130b06e6b4386ef374950e0" => :high_sierra
    sha256 "15626e2bd1f80f15d05562fd25697a0f54476196f3fe52bfb9fc67d432d34de4" => :sierra
    sha256 "51a57b3a49a2d65ceda86c6401303c514b940d9adeb54659d0d4aac34aa89fde" => :el_capitan
  end

  option "without-python", "Build without python2 support"

  depends_on "python3" => :optional
  depends_on "swig" => :build if build.with?("python") || build.with?("python3")

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
