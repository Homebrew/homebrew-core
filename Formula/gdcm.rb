class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://github.com/malaterre/GDCM/archive/v3.0.20.tar.gz"
  sha256 "18161bd76008f4e8a0a33dab72fa34684147e8164f25a4735f373ad4bd909636"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "2088768166efa18eee1c6e6149eb19b4f95df31c5437ee0f6273ff23bcbbe3a1"
    sha256 arm64_monterey: "e224af67eb4d044addc014323a3e88721f19dfc8589f7d11f99b03b2916c6e33"
    sha256 arm64_big_sur:  "17c3d0f214aacc64ce87645daede1cf4e57aab89efbbbde7dcc3706c32576978"
    sha256 ventura:        "13e0d4fcf47756797f45b01a66632b74d2cf3f56651fd72a8a34eb027534d0a0"
    sha256 monterey:       "57b30dfdf01965e50ecbec7dac8449bbf1fd8905febdb724c2082570709899a6"
    sha256 big_sur:        "029180bc81362c90b7ea004e78c7c7cf58901c6d784ad8fe86f1f458702852b0"
    sha256 catalina:       "62aabb2cdef58d8b641c166c75288aac9a1e562f2b45f9de360477dfce22b930"
    sha256 x86_64_linux:   "a707c48bac6d74008024d251084cc41c2d83d66765f05201ae7da2f720893fe1"
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
