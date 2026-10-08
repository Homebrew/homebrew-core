class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://github.com/malaterre/GDCM/archive/refs/tags/v3.2.7.tar.gz"
  sha256 "b7b17b70c009677cf244cc7837b88386441e097f8861fdeee83aa27d1bc1b090"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "2ee1cedcbe12a7dc904cd90dd2fed07b4359e815c2b8fc5005999caec69016ea"
    sha256 arm64_tahoe:       "da182dcf5e433917b034fe4c92847c314813abc756a5baa9ecd2d0753099d784"
    sha256 arm64_sequoia:     "06bea333e514d4d2e03e497b03551efbc585b88519a22a0aa14e74e85053a93c"
    sha256 arm64_linux:       "9f615c631ef1255e11832d527393b73030b014df150619a12da12ecca9af4928"
    sha256 x86_64_linux:      "5561c82eade00a159c1de70e2e1ff9d508667ab57192f6d24965b10e209a5210"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test] # for bindings, avoid runtime dependency due to `expat`
  depends_on "swig" => :build
  depends_on "charls"
  depends_on "json-c"
  depends_on "openjpeg"
  depends_on "openssl@4"

  uses_from_macos "expat"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "python@3.14"
    depends_on "util-linux" # for libuuid
    depends_on "zlib-ng-compat"
  end

  # Fix build with SWIG 4.5.0+ which removed Python 2 compatibility macros
  patch do
    url "https://github.com/malaterre/GDCM/commit/5ebde0b55256142fbfe1b86f010109144ed35251.patch?full_index=1"
    sha256 "40165c0b18539f9b68956fd1cb17dd7566b4282472facf843c32c1f28fe6d792"
    type :unofficial
    resolves "https://github.com/malaterre/GDCM/pull/232"
  end

  def install
    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}/include/python#{xy}"
    else
      formula_opt_include("python@#{xy}")/"python#{xy}"
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
