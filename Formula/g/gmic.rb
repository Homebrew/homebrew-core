class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.5.3.tar.gz"
  sha256 "e91a7cac4d0dc7c0ca2620f03bb14af82aa738c85a11b4f82fcc738654606442"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5a8889269d4c1c411b8e3742b3b0fb0a48070f9117be92623c05d5073332e2dc"
    sha256 cellar: :any,                 arm64_sonoma:  "d4ce0e0719a632356eca4d5545925cab439a987418d7f195d5be41ec88a7dac8"
    sha256 cellar: :any,                 arm64_ventura: "fdb94e87574e1895f1704d4746193c21536ffe41b1f2287f7dcffbdcc9e6f593"
    sha256 cellar: :any,                 sonoma:        "18d3bcdda53c63b969b475761501db00e0cc69b9928238f8ef6265c8113ebc99"
    sha256 cellar: :any,                 ventura:       "4c3d24333d6e54a7865449b491e59bddbfe28e07c3b3ca480d07ecd757cf1a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "351cd4a724f7549e01cc27e1d2213135a611260293119529505b075ce196d0e6"
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
