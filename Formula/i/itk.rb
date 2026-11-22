class Itk < Formula
  desc "Insight Toolkit is a toolkit for performing registration and segmentation"
  homepage "https://itk.org"
  url "https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.4.8/InsightToolkit-5.4.8.tar.gz"
  sha256 "f4f6900f5049c3dbdf5d717798615615b21efc20bab883daf4498905c6712824"
  license "Apache-2.0"
  head "https://github.com/InsightSoftwareConsortium/ITK.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "6b7530683d6c45f4f0a88135a67d834f09f2a17c16a6f586fcb7acb4a2da70a1"
    sha256 arm64_tahoe:       "44a809e493cb4aedd21711c7c9adf70016a2d3fd29e8f7be3435fa6a6155a729"
    sha256 arm64_sequoia:     "b7a74d583fc5ae57cd25120dd8ca2c8a8d0e613ac6004855cfd77b580f93952c"
    sha256 arm64_sonoma:      "7ce1f34e9e19b9f8efe1652c7ec0581a0ad04703d6f1faa1996853af92a9f9bc"
    sha256 arm64_linux:       "990b689e0df7bf101ae3d723322f517f9ff7ab9aadf6ae33418e8e5947fc0bb7"
    sha256 x86_64_linux:      "1f32a7e76e02701e82cc14d72bc9c183c8c49a250a348150a97c8e2caf5963aa"
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

  uses_from_macos "expat", since: :sequoia

  on_macos do
    depends_on "freetype"
    depends_on "glew"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "unixodbc"
    depends_on "zlib-ng-compat"
  end

  resource "scifio-imageio" do
    url "https://github.com/scifio/scifio-imageio/archive/247ada6ab94a2fd2f7ef4519358abd951ddb3649.tar.gz"
    sha256 "50ed8a32da408a5f0425584189def09fe4c003d486d47fcd642cad05d25fb50c"
  end

  resource "bioformats-package" do
    url "https://downloads.openmicroscopy.org/bio-formats/6.3.0/artifacts/bioformats_package.jar"
    sha256 "a8ee4978307bba0851da2173bca2575012e0c8ce1dbc9d2e3285df02ff163831"
  end

  resource "scifio-itk-bridge" do
    url "https://maven.scijava.org/content/repositories/releases/io/scif/scifio-itk-bridge/1.2.1/scifio-itk-bridge-1.2.1.jar"
    sha256 "1bc12d8ff6f540bd81ea8a45fc3e25ac86c1092e0539a64496351c8ec8a64b54"
  end

  deny_network_access!

  def install
    # Avoid CMake trying to find GoogleTest even though tests are disabled
    rm_r(buildpath/"Modules/ThirdParty/GoogleTest")

    scifio = buildpath/"Modules/Remote/SCIFIO"
    resource("scifio-imageio").stage scifio
    # Do not download the bundled JRE, which is not shipped in the bottle.
    inreplace scifio/"src/CMakeLists.txt", "unset(jreFileNameBase)", "unset(jreFileName)"
    (buildpath/"build/lib/jars").install(
      resource("bioformats-package").cached_download => "bioformats_package.jar",
      resource("scifio-itk-bridge").cached_download  => "scifio-itk-bridge.jar",
    )

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DITKV3_COMPATIBILITY:BOOL=OFF
      -DITK_FORBID_DOWNLOADS=ON
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
  end

  test do
    (testpath/"test.cxx").write <<~CPP
      #include "itkImage.h"
      int main(int argc, char* argv[])
      {
        typedef itk::Image<unsigned short, 3> ImageType;
        ImageType::Pointer image = ImageType::New();
        image->Update();
        return EXIT_SUCCESS;
      }
    CPP

    v = version.major_minor
    # Build step
    system ENV.cxx, "-std=c++17", "-isystem", "#{include}/ITK-#{v}", "-o", "test.cxx.o", "-c", "test.cxx"
    # Linking step
    system ENV.cxx, "-std=c++17", "test.cxx.o", "-o", "test",
                    lib/shared_library("libITKCommon-#{v}", 1),
                    lib/shared_library("libITKVNLInstantiation-#{v}", 1),
                    lib/shared_library("libitkvnl_algo-#{v}", 1),
                    lib/shared_library("libitkvnl-#{v}", 1)
    system "./test"
  end
end
