class Itk < Formula
  desc "Insight Toolkit is a toolkit for performing registration and segmentation"
  homepage "https://itk.org"
  url "https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.2.1/InsightToolkit-5.2.1.tar.gz"
  sha256 "192d41bcdd258273d88069094f98c61c38693553fd751b54f8cda308439555db"
  license "Apache-2.0"
  revision 4
  head "https://github.com/InsightSoftwareConsortium/ITK.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "f53ec6554cc1d9b0bc41fe37a5ba183acc04410c932e9290deb4cb8b469232bd"
    sha256 arm64_big_sur:  "aba2287bf5d7f25b9a141fd123c04abdcd12aa970d09815118979b475ab6daf5"
    sha256 monterey:       "6c32846d72a91f1ae1d2ed1e4f5d306826abc0087b30e0a5a5115eef79e8a6bb"
    sha256 big_sur:        "c2dac27e4b6818a6472e2d28438f41a45280ec7be67b710eb2c6508b3007fe3f"
    sha256 catalina:       "b3a6984b550cdae671d061175c4a8193c7c3d7e37cc5c5d2c0c49f8f94f1217d"
    sha256 x86_64_linux:   "8371e79ea8dd12072ad133544f757dfa2e25a9939dd5d736fdb2b0d65198ce13"
  end

  depends_on "cmake" => :build
  depends_on "double-conversion"
  depends_on "fftw"
  depends_on "gdcm"
  depends_on "hdf5"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "vtk"

  on_linux do
    depends_on "alsa-lib"
    depends_on "unixodbc"

    ignore_missing_libraries "libjvm.so"
  end

  fails_with gcc: "5"

  def install
    # Avoid CMake trying to find GoogleTest even though tests are disabled
    (buildpath/"Modules/ThirdParty/GoogleTest").rmtree

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DITKV3_COMPATIBILITY:BOOL=OFF
      -DITK_LEGACY_REMOVE=ON
      -DITK_USE_64BITS_IDS=ON
      -DITK_USE_FFTWF=ON
      -DITK_USE_FFTWD=ON
      -DITK_USE_SYSTEM_FFTW=ON
      -DITK_USE_SYSTEM_HDF5=ON
      -DITK_USE_SYSTEM_JPEG=ON
      -DITK_USE_SYSTEM_PNG=ON
      -DITK_USE_SYSTEM_TIFF=ON
      -DITK_USE_SYSTEM_GDCM=ON
      -DITK_USE_SYSTEM_ZLIB=ON
      -DITK_USE_SYSTEM_EXPAT=ON
      -DITK_USE_SYSTEM_DOUBLECONVERSION=ON
      -DITK_USE_SYSTEM_LIBRARIES=ON
      -DModule_ITKReview=ON
      -DModule_ITKVtkGlue=ON
      -DModule_SCIFIO=ON
    ]
    args << "-DITK_USE_GPU=ON" if OS.mac?

    # Avoid references to the Homebrew shims directory
    inreplace "Modules/Core/Common/src/CMakeLists.txt" do |s|
      s.gsub!(/MAKE_MAP_ENTRY\(\s*\\"CMAKE_C_COMPILER\\",
              \s*\\"\${CMAKE_C_COMPILER}\\".*\);/x,
              "MAKE_MAP_ENTRY(\\\"CMAKE_C_COMPILER\\\", " \
              "\\\"#{ENV.cc}\\\", \\\"The C compiler.\\\");")

      s.gsub!(/MAKE_MAP_ENTRY\(\s*\\"CMAKE_CXX_COMPILER\\",
              \s*\\"\${CMAKE_CXX_COMPILER}\\".*\);/x,
              "MAKE_MAP_ENTRY(\\\"CMAKE_CXX_COMPILER\\\", " \
              "\\\"#{ENV.cxx}\\\", \\\"The CXX compiler.\\\");")
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cxx").write <<-EOS
      #include "itkImage.h"
      int main(int argc, char* argv[])
      {
        typedef itk::Image<unsigned short, 3> ImageType;
        ImageType::Pointer image = ImageType::New();
        image->Update();
        return EXIT_SUCCESS;
      }
    EOS

    v = version.major_minor
    # Build step
    system ENV.cxx, "-std=c++11", "-isystem", "#{include}/ITK-#{v}", "-o", "test.cxx.o", "-c", "test.cxx"
    # Linking step
    system ENV.cxx, "-std=c++11", "test.cxx.o", "-o", "test",
                    lib/shared_library("libITKCommon-#{v}", 1),
                    lib/shared_library("libITKVNLInstantiation-#{v}", 1),
                    lib/shared_library("libitkvnl_algo-#{v}", 1),
                    lib/shared_library("libitkvnl-#{v}", 1)
    system "./test"
  end
end
