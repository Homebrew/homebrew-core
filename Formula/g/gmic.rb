class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.5.5.tar.gz"
  sha256 "f77999dbb6cd95e2766a0fa1c6ea3ec61007a981ff4644cba2cfba895ec1dff3"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5cb0889078eb1dfa8565f14e977ffb89fa50ca7535e0f6541696ad2f08d06e4b"
    sha256 cellar: :any,                 arm64_sonoma:  "07dbc62de61547e82218e90c874dd5c93a3647a31396fb48223e5869418e34b4"
    sha256 cellar: :any,                 arm64_ventura: "3039cf36ec46b41e4bc435cbb1d9921e3338fd0d4602281bfd132b3165c5062e"
    sha256 cellar: :any,                 sonoma:        "d1862c42718723ac94ac67a7dbc06ec53edc43cd0aa86b69a5431ac3f2cd0e2a"
    sha256 cellar: :any,                 ventura:       "01cc3ca249b7b60bd921dea6b0daa3b4a5c168e87246b462defefe6e9acc26dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c08abb7a964d41da196916cce2441c6250a1674f00007fe5e5d0f66b0b59ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62fa1665718a1ba100c3d3be910f5283c831dbc6e139db8d8bb7036e8fc15626"
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
