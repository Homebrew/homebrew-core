class Itk < Formula
  desc "Insight Toolkit is a toolkit for performing registration and segmentation"
  homepage "https://itk.org"
  url "https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.4.5/InsightToolkit-5.4.5.tar.gz"
  sha256 "ecab9119664e2571b90740ba9ab3ca11cb46942dbd7bb87c0de5bb15309a36c9"
  license "Apache-2.0"
  revision 2
  head "https://github.com/InsightSoftwareConsortium/ITK.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "b2a8f96cd226af1a815933d1daee93c710ceaafaac326c8820a9104427df3917"
    sha256 arm64_sequoia: "23133969310686e96f33a55f517f0fb41e20d13211cae77bcfaf9a9072385faa"
    sha256 arm64_sonoma:  "4f9be429fe1e5c8f5e86a3aaf829223407acf93f9fa6f88fdc7fafc691acd8ee"
    sha256 sonoma:        "b1a1409ea3e92ab6adcb31ae2d234ae0eddd7b835a267ea026f578f876377c3e"
    sha256 arm64_linux:   "da238b4ffceb9c53fd94bba8ba720d714173fd072c31729008bec80314c81b4f"
    sha256 x86_64_linux:  "94c87addcf68107b478da8dde5df4ae2c5d82f98c104765dc8cfed670adbb6ec"
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

  # Work around superenv to avoid mixing `expat` usage in libraries across dependency tree.
  # Brew `expat` usage in Python has low impact as it isn't loaded unless pyexpat is used.
  # TODO: Consider adding a DSL for this or change how we handle Python's `expat` dependency
  def remove_brew_expat
    env_vars = %w[CMAKE_PREFIX_PATH HOMEBREW_INCLUDE_PATHS HOMEBREW_LIBRARY_PATHS PATH PKG_CONFIG_PATH]
    ENV.remove env_vars, /(^|:)#{Regexp.escape(Formula["expat"].opt_prefix)}[^:]*/
    ENV.remove "HOMEBREW_DEPENDENCIES", "expat"
  end

  def install
    remove_brew_expat if OS.mac? && MacOS.version < :sequoia

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
