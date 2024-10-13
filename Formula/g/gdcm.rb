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
    sha256 arm64_sequoia:  "58ab3720e3224ffe2eddf7fdc9c09786dc6d9aedc9137ad041cd0593f72aa0a7"
    sha256 arm64_sonoma:   "b3c59d76d3075c22b131d69ffa1692c28a0fd2357a537b57b412e026f0a2d382"
    sha256 arm64_ventura:  "847ee192e58ed159a28116d4e02c849203adff75eee0bc27e865a1c9269966aa"
    sha256 arm64_monterey: "6e2a348a3aab4f5193aad6120e780605a3022393a4ffdb0af363dd89d306ab6e"
    sha256 sonoma:         "e98f96ff6b897d241feddb12eb0d1340b612e033126f52dc9a675465d88c11d0"
    sha256 ventura:        "8bada768a0e1349507f4e8c4cfece34f606c168bae51b81e2df16bc2ec98916d"
    sha256 monterey:       "fd68db00f804806164c14a880ac66b107892461753d55731d134b39a06deac5b"
    sha256 x86_64_linux:   "fe50e950bb25f9e13d890b92e82570887b3f1bc7174b508a46709a0ffaa35e09"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
