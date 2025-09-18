class Itk < Formula
  desc "Insight Toolkit is a toolkit for performing registration and segmentation"
  homepage "https://itk.org"
  url "https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.4.4/InsightToolkit-5.4.4.tar.gz"
  sha256 "d2092cd018a7b9d88e8c3dda04acb7f9345ab50619b79800688c7bc3afcca82a"
  license "Apache-2.0"
  revision 2
  head "https://github.com/InsightSoftwareConsortium/ITK.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "2a5f4047de6894d22c9c0c01405747c0c91985f22efe65e48fc438d52cf29aa0"
    sha256                               arm64_sequoia: "adf6a5810423f0cefef0524fe1ea63d58cd8e554b615f92de39a1c1c809c5185"
    sha256                               arm64_sonoma:  "da3b07d924f8b330b6d11808742d136e23356e1e9e2d4da49f0c2a176cde599f"
    sha256                               arm64_ventura: "b4c53c3414abe1b5b3c0eee1a3fa2a68638ec8ac3874e9a3332d25574c3ddeba"
    sha256                               sonoma:        "f9f41f0a46a40bab2c40eadd12fdcc5b6c75cb86f1fcdc9b65787285a3e2646d"
    sha256                               ventura:       "5d1e6fb10b8a8ef034300ea370741bd813358484718ab078b22c2403db602a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "049f0ade18dee815863ffdaff64774b0ce8358528a04e8f3cecfd039514f3581"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "freetype"
    depends_on "glew"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "unixodbc"
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
