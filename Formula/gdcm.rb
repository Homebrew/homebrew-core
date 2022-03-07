class Gdcm < Formula
  desc "Grassroots DICOM library and utilities for medical files"
  homepage "https://sourceforge.net/projects/gdcm/"
  url "https://github.com/malaterre/GDCM/archive/v3.0.10.tar.gz"
  sha256 "a3fd3579ca0bb4a2a41ee18770e7303b22fd5460c3a2000e51ff0be6799e1d85"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "079d2b926e385a57861a4a49c1adadb0807ef6c7b13aa4b2376535219974bc64"
    sha256 arm64_big_sur:  "5dcabe7f86535f8286e5a52a59e01fa5e3783f6052fd1add90b1cb9914dab07c"
    sha256 monterey:       "b503491bddfbce1aee99d8b4632711cd4231b3ede20d16cbc92fa8c4f6a1b060"
    sha256 big_sur:        "2444192229efedacb3148eca8648221ea1c609d3e88d32e4097a12b3d1c9ff20"
    sha256 catalina:       "18ffa7ef542d0ab58e2666fb254fe26bf9809d3fd00cd6c14b2de38adb164ed5"
    sha256 x86_64_linux:   "922e0fbed6f8bc970af36086db9df457fc7c129022a75a3d925e4d832b3b3540"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "openjpeg"
  depends_on "openssl@1.1"
  depends_on "python@3.9"
  depends_on "vtk@8.2"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11

    python3 = Formula["python@3.9"].opt_bin/"python3"
    xy = Language::Python.major_minor_version python3
    python_include =
      Utils.safe_popen_read(python3, "-c", "from distutils import sysconfig;print(sysconfig.get_python_inc(True))")
           .chomp
    python_executable = Utils.safe_popen_read(python3, "-c", "import sys;print(sys.executable)").chomp

    args = std_cmake_args + %W[
      -GNinja
      -DGDCM_BUILD_APPLICATIONS=ON
      -DGDCM_BUILD_SHARED_LIBS=ON
      -DGDCM_BUILD_TESTING=OFF
      -DGDCM_BUILD_EXAMPLES=OFF
      -DGDCM_BUILD_DOCBOOK_MANPAGES=OFF
      -DGDCM_USE_VTK=ON
      -DGDCM_USE_SYSTEM_EXPAT=ON
      -DGDCM_USE_SYSTEM_ZLIB=ON
      -DGDCM_USE_SYSTEM_UUID=ON
      -DGDCM_USE_SYSTEM_OPENJPEG=ON
      -DGDCM_USE_SYSTEM_OPENSSL=ON
      -DGDCM_WRAP_PYTHON=ON
      -DPYTHON_EXECUTABLE=#{python_executable}
      -DPYTHON_INCLUDE_DIR=#{python_include}
      -DGDCM_INSTALL_PYTHONMODULE_DIR=#{lib}/python#{xy}/site-packages
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DGDCM_NO_PYTHON_LIBS_LINKING=ON
    ]

    mkdir "build" do
      ENV.append "LDFLAGS", "-undefined dynamic_lookup" if OS.mac?

      system "cmake", "..", *args
      system "ninja"
      system "ninja", "install"
    end
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

    system Formula["python@3.9"].opt_bin/"python3", "-c", "import gdcm"
  end
end
