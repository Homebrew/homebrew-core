class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://github.com/malaterre/GDCM/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "133078bfff4fe850a1faaea44b0a907ba93579fd16f34c956f4d665b24b590e5"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "6ce4c09d9f7fa7bda95ddc5d5e985f1ca279ddfd4b6250d477ac63ba6c5de68a"
    sha256 arm64_sequoia: "56944709b1eef3d27bb1874f2b98de671f827df3a0a7cbded98564e80628082b"
    sha256 arm64_sonoma:  "edef8d78b79f9648e3f32994001a6df3dc04901ab9ac3d9766295d51598ad1c0"
    sha256 sonoma:        "c2dd510832249deb9315ef84a2fd22098babae2ddd6457c263f5ca5ce42d54d5"
    sha256 arm64_linux:   "1c1a09e9234fb742986f0436b65c827aa945d9e366d1242e07e2e277c9ecd469"
    sha256 x86_64_linux:  "4ba447c88a6e8ac5489bae3ede532c45669f55d50e9ed89eba2fd82b86dc4ad5"
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
  uses_from_macos "zlib"

  on_linux do
    depends_on "python@3.14"
    depends_on "util-linux" # for libuuid
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
