class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://github.com/malaterre/GDCM/archive/refs/tags/v3.0.24.tar.gz"
  sha256 "d88519a094797c645ca34797a24a14efc10965829c4c3352c8ef33782a556336"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 arm64_sequoia: "29f4afca40589ee225e365d19784cefaea6a645bb74c8846fc380b4ab6182020"
    sha256 arm64_sonoma:  "fde25b20f1705d89a85dec3c6e159877d6725b90ca38574083a3ba6beac9c0b3"
    sha256 arm64_ventura: "5de66afd7a971ab36ee2a088d9cad724e664a9c54f86de0487097d4100603537"
    sha256 sonoma:        "709bd1ed5c21684c70b26bc5eb01557c1651be434a17a7d29bec098c3c4d695b"
    sha256 ventura:       "23c61e5a51e3c5d5b0abb2a9df18b06c4a5eda9e14c05850643bca44a9bdbae1"
    sha256 arm64_linux:   "fd227edb28e56e51c23bf3bbc1d00ab4986e0c0b34ce8927baeb35b74e3741d9"
    sha256 x86_64_linux:  "8bc43d0b2244b3218545c1aa4fba961b365c514d85bb3a158087e4fbe421350d"
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

    system ENV.cxx, "-std=c++11", "test.cxx", "-o", "test", "-I#{include}/gdcm-3.0", "-L#{lib}", "-lgdcmDSED"
    system "./test"

    system python3, "-c", "import gdcm"
  end
end
