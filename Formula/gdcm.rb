class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://github.com/malaterre/GDCM/archive/v3.0.16.tar.gz"
  sha256 "75aaa1e301d2fbf80183e5089419e23207e04a526bd8af72647db789c670f4e2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "e5545cbba07e64949d430fcbf8f748ab44812715981963cacb791fe351caaca6"
    sha256 arm64_big_sur:  "1e9a6f71f51e17fffe1e015ea24a4e3b7d8bf8d000750fccc08cd7c55dc576e8"
    sha256 monterey:       "aaca417828c252769fe1f6dcc392caeea4bffe9c8fdf034dea2d361ca943e914"
    sha256 big_sur:        "55e74700b796709ff3dabf35a1cef14b6e8aa1554f6d81281b3b16b597d93003"
    sha256 catalina:       "5881919c7d28e2eb1ab3f769be347e03c56257761499bc34a25fc5cfbf60c79d"
    sha256 x86_64_linux:   "7811ccfe3dad3ec98dfc068d327bbec0d12b6c9da1f198deab1aede0c2d9b84c"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "openjpeg"
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
    depends_on "util-linux" # for libuuid
  end

  fails_with gcc: "5"

  def python3
    which("python3.10")
  end

  def install
    ENV.cxx11
    ENV.append "LDFLAGS", "-undefined dynamic_lookup" if OS.mac?

    python_include =
      Utils.safe_popen_read(python3, "-c", "from distutils import sysconfig;print(sysconfig.get_python_inc(True))")
           .chomp

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-GNinja",
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
                    "-DGDCM_INSTALL_PYTHONMODULE_DIR=#{prefix/Language::Python.site_packages(python3)}",
                    "-DCMAKE_INSTALL_RPATH=#{lib}",
                    "-DGDCM_NO_PYTHON_LIBS_LINKING=ON"
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
