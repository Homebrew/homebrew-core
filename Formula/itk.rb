class Itk < Formula
  desc "Insight Toolkit is a toolkit for performing registration and segmentation"
  homepage "https://itk.org"
  url "https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.3.0/InsightToolkit-5.3.0.tar.gz"
  sha256 "57a4471133dc8f76bde3d6eb45285c440bd40d113428884a1487472b7b71e383"
  license "Apache-2.0"
  head "https://github.com/InsightSoftwareConsortium/ITK.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "6c5ae4caaa5db0b4c9c5d5947f7432e7933e2ec4b0047ad656318c7eaf291376"
    sha256 arm64_monterey: "999621dcc8212ac650e40035de6c6d9558f7564e2868e09040372d391f8e54e5"
    sha256 arm64_big_sur:  "9d72b5bf086019b8a7b88a24f8188de0f1121630168f54cc94d161d50b8993d8"
    sha256 ventura:        "e18ca58d6e7ef0b136e3d5bac7b13b027c6f21e4d6200c28735828f7eac0c462"
    sha256 monterey:       "05b28cb5148887ced4e7b9f14c8a89b7e0dcfddf812bcecf61ef525703f16f3a"
    sha256 big_sur:        "9220db75ade46836b878577fd095f6998117cdf2a937dd9b68614646e2a2d504"
    sha256 x86_64_linux:   "99ffd8c6b3faf1dcde531cd549571726a3445e5c60173aa6d3e3ceff18e16486"
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
    # Cannot compile on macOS with this arg
    # Upstream issue: https://github.com/InsightSoftwareConsortium/ITK/issues/3821
    # args << "-DITK_USE_GPU=ON" if OS.mac?

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

    # Remove the bundled JRE installed by SCIFIO ImageIO plugin
    (lib/"jre").rmtree if OS.linux? || Hardware::CPU.intel?
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
    system ENV.cxx, "-std=c++14", "-isystem", "#{include}/ITK-#{v}", "-o", "test.cxx.o", "-c", "test.cxx"
    # Linking step
    system ENV.cxx, "-std=c++14", "test.cxx.o", "-o", "test",
                    lib/shared_library("libITKCommon-#{v}", 1),
                    lib/shared_library("libITKVNLInstantiation-#{v}", 1),
                    lib/shared_library("libitkvnl_algo-#{v}", 1),
                    lib/shared_library("libitkvnl-#{v}", 1)
    system "./test"
  end
end
