class Itk < Formula
  desc "Insight Toolkit is a toolkit for performing registration and segmentation"
  homepage "https://itk.org"
  url "https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.4.7/InsightToolkit-5.4.7.tar.gz"
  sha256 "4907033e0e93fb04734df8556b88a670ba630b4f42b52e9f25ed4d084a7ab925"
  license "Apache-2.0"
  head "https://github.com/InsightSoftwareConsortium/ITK.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "08f9400cc184a5bfb38d93c14c921a6e3ac17fa5db210cf4e7ecf21395e3a11a"
    sha256 arm64_sequoia: "e568055ca125c860e2b4005231f9848503834c403912772ce15be7b17f89f9f5"
    sha256 arm64_sonoma:  "8ce6d6fad17cb5348184d29c8b7bd228f0f65b5d2016ed70ddb54f794644af61"
    sha256 sonoma:        "e628abf1080a31f3b9874cab92594e1a09e0e57d43f2ecdeed9d5c46673f5701"
    sha256 arm64_linux:   "ee1bca607c4dba0d81f126c1803ee5ad6e9edcc06e4fc6b4e541d766dc988aae"
    sha256 x86_64_linux:  "9c411822795839d2e5880116843e0a6659e7eac1c984fd3b312eddd27afd4fd0"
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

  uses_from_macos "expat"

  on_macos do
    depends_on "freetype"
    depends_on "glew"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "unixodbc"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.remove_brew_expat if OS.mac? && MacOS.version < :sequoia

    # Avoid CMake trying to find GoogleTest even though tests are disabled
    rm_r(buildpath/"Modules/ThirdParty/GoogleTest")

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
    rm_r(lib/"jre") if OS.linux? || Hardware::CPU.intel?
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
