class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://github.com/malaterre/GDCM/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "133078bfff4fe850a1faaea44b0a907ba93579fd16f34c956f4d665b24b590e5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "df478534e903f2c93f372d060edc4d35c2be4101b34ae0a5f450d27aca9cf239"
    sha256 arm64_sequoia: "dc399581c79b6f0eb62df43c27030b30ba243ccd5a945535a81fd22e46a33d58"
    sha256 arm64_sonoma:  "bcf58fa6bb77335ad410adee85831165170b7f8ebe52f05f6a4160bcef7b4c01"
    sha256 sonoma:        "aea60c7011b3a8fbf80949883159d027acd168f0853f7ad753cb6ae227294dd6"
    sha256 arm64_linux:   "da5f0632e0bb74d78035043778fb3242bd66ef857fc26fb588f5f9816a5c0d5d"
    sha256 x86_64_linux:  "bb889a8dfb5d779e53d532675f2abb66e90958087690487dfc5c7e43a716165e"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test] # for bindings, avoid runtime dependency due to `expat`
  depends_on "swig" => :build
  depends_on "charls"
  depends_on "json-c"
  depends_on "openjpeg"
  depends_on "openssl@3"

  uses_from_macos "expat"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "python@3.13"
    depends_on "util-linux" # for libuuid
  end

  def python3
    which("python3.13")
  end

  def install
    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}/include/python#{xy}"
    else
      Formula["python@#{xy}"].opt_include/"python#{xy}"
    end

    prefix_site_packages = prefix/Language::Python.site_packages(python3)
    args = [
      "-DCMAKE_CXX_STANDARD=11",
      "-DGDCM_BUILD_APPLICATIONS=ON",
      "-DGDCM_BUILD_SHARED_LIBS=ON",
      "-DGDCM_BUILD_TESTING=OFF",
      "-DGDCM_BUILD_EXAMPLES=OFF",
      "-DGDCM_BUILD_DOCBOOK_MANPAGES=OFF",
      "-DGDCM_USE_VTK=OFF", # No VTK 9 support: https://sourceforge.net/p/gdcm/bugs/509/
      "-DGDCM_USE_SYSTEM_CHARLS=ON",
      "-DGDCM_USE_SYSTEM_EXPAT=ON",
      "-DGDCM_USE_SYSTEM_JSON=ON",
      "-DGDCM_USE_SYSTEM_LIBXML2=ON",
      "-DGDCM_USE_SYSTEM_OPENJPEG=ON",
      "-DGDCM_USE_SYSTEM_OPENSSL=ON",
      "-DGDCM_USE_SYSTEM_UUID=ON",
      "-DGDCM_USE_SYSTEM_ZLIB=ON",
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
    (testpath/"test.cxx").write <<~CPP
      #include "gdcmReader.h"
      int main(int, char *[])
      {
        gdcm::Reader reader;
        reader.SetFileName("file.dcm");
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cxx", "-o", "test", "-I#{include}/gdcm-#{version.major_minor}", "-L#{lib}", "-lgdcmDSED"
    system "./test"

    system python3, "-c", "import gdcm"
  end
end
