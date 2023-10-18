class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://github.com/malaterre/GDCM/archive/v3.0.22.tar.gz"
  sha256 "2ee9bf6787046a508ec3fe38e3cf85ab074e11de2e503bdaf8f30f00cbeff386"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "2372b73012edfdf0b2078851464821dc19e5559b122589dbe7990ad9f267cb26"
    sha256 arm64_ventura:  "9b8389708608cfeee3e19dc08adbf182b95b40889f48d33da301e2eb987689b2"
    sha256 arm64_monterey: "4170bdf4dfea969a8d303689274f2a8d260483f168933dfc80d72dd13cae9730"
    sha256 sonoma:         "79950fed2fdaf8fdef5a0155ad46f30b288d25220ce303977aa3446e634a4941"
    sha256 ventura:        "bba66919226b16325cabc13fc475cffa877b741fed9d936271f79912091c05e5"
    sha256 monterey:       "e187506a26d6814eed9e365e263f64e5152a0418f939e89055855cb2db793b52"
    sha256 x86_64_linux:   "7711ed6f5c117d63f2735b39249bc7cf4c6dc32098d62135add21b02f5b86380"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "openjpeg"
  depends_on "openssl@3"
  depends_on "python@3.12"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" # for libuuid
  end

  fails_with gcc: "5"

  def python3
    which("python3.12")
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
