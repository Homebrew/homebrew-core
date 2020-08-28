class Itk < Formula
  desc "Insight Toolkit is a toolkit for performing registration and segmentation"
  homepage "https://itk.org"
  url "https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.1.0/InsightToolkit-5.1.0.tar.gz"
  sha256 "121020a1611508cec8123eb5226215598cec07be627d843a2e6b6da891e61d13"
  license "Apache-2.0"
  head "https://github.com/InsightSoftwareConsortium/ITK.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "a164746cce8e23e169a967bae3c8b455f63674ee3e74f677d7e1214253db3975" => :catalina
    sha256 "e633ca1823a1f35e0d2e025a4f2ce7e1cad26342d934e9a41a29396e0808f374" => :mojave
    sha256 "d7e3580065e5c49d5af1a403bbb7a3a0532471494c87e15f50ca295c74a30123" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gdcm"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "vtk"

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
      -DModule_ITKLevelSetsv4Visualization=ON
      -DModule_ITKReview=ON
      -DModule_ITKVtkGlue=ON
      -DITK_USE_GPU=ON
    ]

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
                    "#{lib}/libITKCommon-#{v}.1.dylib",
                    "#{lib}/libITKVNLInstantiation-#{v}.1.dylib",
                    "#{lib}/libitkvnl_algo-#{v}.1.dylib",
                    "#{lib}/libitkvnl-#{v}.1.dylib"
    system "./test"
  end
end
