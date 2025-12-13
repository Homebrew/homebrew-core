class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.6.5.tar.gz"
  sha256 "0987e54d64dc3a82df6a3052e6aa5d5b5f1e9115c6fd4155e1aceb78e462169a"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a0d3d59f04a9702ecf806176ef85a83085d72c23d61540d410476be18c92722"
    sha256 cellar: :any,                 arm64_sequoia: "6e7739391025393b1d3a32c0becd3c077c1dc77589c90957ead98a45242d7ee8"
    sha256 cellar: :any,                 arm64_sonoma:  "30a5692fe4366c1f00a942377ba33454b2e3662bec5213910411b152bc5683d2"
    sha256 cellar: :any,                 sonoma:        "279e348cd7b8b806d078647101e3ae39b953bd95b1f7c02e8123a19a8511f349"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e0279e4a720ba23d3302d56232fc4adcfcfed023e67f6734046dd71eb4a1e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4106a371247d419776226d193ca932c6e8d5c1dff5d87fd2fbb86eed01419cb6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cimg"
  depends_on "fftw"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"

    on_arm do
      depends_on "gcc" => :build if DevelopmentTools.gcc_version("gcc") < 13

      fails_with :gcc do
        version "12"
        cause <<~CAUSE
          Fails to compile because of undefined `_Float16` type
          https://godbolt.org/z/nKbrjPTvG
        CAUSE
      end
    end
  end

  def install
    args = %W[
      -DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}
      -DENABLE_DYNAMIC_LINKING=ON
      -DENABLE_FFMPEG=OFF
      -DENABLE_GRAPHICSMAGICK=OFF
      -DUSE_SYSTEM_CIMG=ON
    ]
    if OS.mac?
      args << "-DENABLE_X=OFF"
      inreplace "CMakeLists.txt", "COMMAND LD_LIBRARY_PATH", "COMMAND DYLD_LIBRARY_PATH"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin/"gmic", test_fixtures(file)
    end
    system bin/"gmic", "-input", test_fixtures("test.jpg"), "rodilius", "10,4,400,16",
           "smooth", "60,0,1,1,4", "normalize_local", "10,16", "-output", testpath/"test_rodilius.jpg"
    assert_path_exists testpath/"test_rodilius.jpg"
  end
end
