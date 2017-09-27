class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://downloads.sourceforge.net/project/gdcm/gdcm%202.x/GDCM%202.8.2/gdcm-2.8.2.tar.gz"
  sha256 "5462c7859e01e5d5d0fb86a19a6c775484a6c44abd8545ea71180d4c41bf0f89"
  revision 1

  bottle do
    sha256 "3fd15851c093b4e0c2481233268e41614b26dde24aa2c13f9107402ae8bf2ddd" => :high_sierra
    sha256 "4fad6b9761ca2ab4c9b26b418d57ef26f2dd19bebb77a658b5b5aadda0212098" => :sierra
    sha256 "dbfbcaa31ceaedc98985614899601f771e951cbd6c115223082ab73ef111f231" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "vtk"

  needs :cxx11

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", "-DGDCM_BUILD_APPLICATIONS=ON",
                            "-DGDCM_BUILD_SHARED_LIBS=ON",
                            "-DGDCM_BUILD_TESTING=OFF",
                            "-DGDCM_BUILD_EXAMPLES=OFF",
                            "-DGDCM_BUILD_DOCBOOK_MANPAGES=OFF",
                            "-DGDCM_USE_VTK=ON",
                            "-DGDCM_USE_SYSTEM_OPENSSL=ON",
                            *std_cmake_args
      system "make", "install"
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
  end
end
