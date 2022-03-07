class Itk < Formula
  desc "Insight Toolkit is a toolkit for performing registration and segmentation"
  homepage "https://itk.org"
  url "https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.2.1/InsightToolkit-5.2.1.tar.gz"
  sha256 "192d41bcdd258273d88069094f98c61c38693553fd751b54f8cda308439555db"
  license "Apache-2.0"
  revision 1
  head "https://github.com/InsightSoftwareConsortium/ITK.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "d0d84e530fc37f325faca65c66509d1657cb1e8b8b4ba12f463d53f696cf7ee1"
    sha256 arm64_big_sur:  "b12344d4d532d45ecc2b26460098d94c3600fae18783c09ba28772c981df32ef"
    sha256 monterey:       "6196f661aa3ce5b1373adb10bdd8fd6f5545ed1b2d2523484281c78da52edc16"
    sha256 big_sur:        "3bdc918b3060cafc667a89fbe1c3600ab16e92ea511b894f843bac9e30d71faa"
    sha256 catalina:       "bd8d199e8f6940481bd14ca9f7ec10a260ed905c6136a5e669b1918fec6b109c"
    sha256 x86_64_linux:   "c523cc44cdd24cd80b3903e49ebe08088664ef3ef88dab83570c665b2645669b"
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gdcm"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "vtk@8.2" # needed for gdcm

  on_linux do
    depends_on "alsa-lib"
    depends_on "gcc"
    depends_on "unixodbc"

    ignore_missing_libraries "libjvm.so"
  end

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTING=OFF
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DITK_USE_64BITS_IDS=ON
      -DITK_USE_STRICT_CONCEPT_CHECKING=ON
      -DITK_USE_SYSTEM_ZLIB=ON
      -DITK_USE_SYSTEM_EXPAT=ON
      -DModule_SCIFIO=ON
      -DITKV3_COMPATIBILITY:BOOL=OFF
      -DITK_USE_SYSTEM_FFTW=ON
      -DITK_USE_FFTWF=ON
      -DITK_USE_FFTWD=ON
      -DITK_USE_SYSTEM_HDF5=ON
      -DITK_USE_SYSTEM_JPEG=ON
      -DITK_USE_SYSTEM_PNG=ON
      -DITK_USE_SYSTEM_TIFF=ON
      -DITK_USE_SYSTEM_GDCM=ON
      -DITK_LEGACY_REMOVE=ON
      -DModule_ITKReview=ON
      -DModule_ITKVtkGlue=ON
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

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
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
                    shared_library("#{lib}/libITKCommon-#{v}", 1),
                    shared_library("#{lib}/libITKVNLInstantiation-#{v}", 1),
                    shared_library("#{lib}/libitkvnl_algo-#{v}", 1),
                    shared_library("#{lib}/libitkvnl-#{v}", 1)
    system "./test"
  end
end
