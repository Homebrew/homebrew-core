class Itk < Formula
  desc "Insight Toolkit is a toolkit for performing registration and segmentation"
  homepage "https://itk.org"
  url "https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.2.1/InsightToolkit-5.2.1.tar.gz"
  sha256 "192d41bcdd258273d88069094f98c61c38693553fd751b54f8cda308439555db"
  license "Apache-2.0"
  revision 2
  head "https://github.com/InsightSoftwareConsortium/ITK.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "61495c81d0131912bb28cca71f5194361f8b0f0771c2ff33d61020f04a7d35cd"
    sha256 arm64_big_sur:  "334aab09cb5b4244dbb87831929294648e1194aa5be370b62208825ed128b064"
    sha256 monterey:       "5888e5ec1cfce99a2d8eb26704b0f357f7e2e11ec62ae4bcce828fbb0cb128eb"
    sha256 big_sur:        "325f815e996d953f180429e20db4765e894f201c07f1a465ae1f4690346852d5"
    sha256 catalina:       "040cb820d85b99db6c07bb18e20e150146cea866a399303f30e128cbdbeb3646"
    sha256 x86_64_linux:   "4ce4d3bf54ace26caab4df9f975bf39e8abc454983130b8d37d9d1f2cde3f210"
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
