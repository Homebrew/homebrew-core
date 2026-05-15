class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://github.com/malaterre/GDCM/archive/refs/tags/v3.2.6.tar.gz"
  sha256 "cac56100de60aba8ef9ff3af5befb5307a99e425864544ce8277df056c1e20a6"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "ccc916d2f436641dc57ef47cc42621d982d4c4f78ee065bfb4f8b7fa8373b739"
    sha256 arm64_sequoia: "00c8e96f2057d7799a2f3ee572e4eeca2540f093c71347480b1d100eabe26a73"
    sha256 arm64_sonoma:  "bcaa57f56d392eb8a56785c698dc89d15ddb5ac2e58b33dcd5dea5af7ebcb163"
    sha256 sonoma:        "e1f978a314fd982f9a522fc10f8d8eaa4b8ec464c435cb3ff720e41989d19e21"
    sha256 arm64_linux:   "ec3da1d9d8dad5857748363699f261593abc790cfabcb1b936a47044f22eff0f"
    sha256 x86_64_linux:  "4ef06462203ebc92adb899b192c70b62074c048777aeaf6fca146da1c3257b6e"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test] # for bindings, avoid runtime dependency due to `expat`
  depends_on "swig" => :build
  depends_on "charls"
  depends_on "json-c"
  depends_on "openjpeg"
  depends_on "openssl@3"

  uses_from_macos "expat"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "python@3.14"
    depends_on "util-linux" # for libuuid
    depends_on "zlib-ng-compat"
  end

  def python3
    which("python3.14")
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
