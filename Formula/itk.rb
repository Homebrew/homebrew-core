class Itk < Formula
  desc "Insight Toolkit is a toolkit for performing registration and segmentation"
  homepage "https://itk.org"
  url "https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.2.1/InsightToolkit-5.2.1.tar.gz"
  sha256 "192d41bcdd258273d88069094f98c61c38693553fd751b54f8cda308439555db"
  license "Apache-2.0"
  revision 3
  head "https://github.com/InsightSoftwareConsortium/ITK.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "ed0de1d339aff119c2640e3a1005f839df71d72512bfbc6c8e4674a8cba6594e"
    sha256 arm64_big_sur:  "88225bc780b95cbd930e3720f7bcc642486696af3d09ef1c11496be48e861877"
    sha256 monterey:       "3ad1e354b45ecc757531b9d6b1824008bdd673a2f2a79a97d61df9e03691b1a0"
    sha256 big_sur:        "29954b98ab4258d589f1a67f159444f56565b3b9bf1668856ebf6dfc26b79d6b"
    sha256 catalina:       "635a00672c346af5b3e89dec3ebe8d8427068f1f28f0b187210a9e4b16c55cf8"
    sha256 x86_64_linux:   "00848dadfd40fb0004e7e6fdd5e244f2803e4f376ced6dfa552c24081899a90f"
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
