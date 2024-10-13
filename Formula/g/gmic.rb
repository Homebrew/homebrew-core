class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.4.3.tar.gz"
  sha256 "79951d06db2928c68bad1d352e536af3f454e9a3c09beefc2c1049d8b4084507"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a81973227c6fecf458cc4d7fbdc791e252163bf6aca986bce72be913c729b4bd"
    sha256 cellar: :any,                 arm64_sonoma:  "1f54cf4661262c4cea2f68540559f81629675c29daa00f6ce791386030361526"
    sha256 cellar: :any,                 arm64_ventura: "564d98e261a7ba3f83718d6f9455424db320a365c6b187e497e9d7b159fd85d8"
    sha256 cellar: :any,                 sonoma:        "ae4ccc1771af3f2169ebab9f0388873779739da7e38f304b76ca5ef948658e52"
    sha256 cellar: :any,                 ventura:       "2854b94bb3ccd14d2a9114655dedbd218cafbcf6c8e30e8f47cb81cba3a998c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1daae27036c6d670c516e1144536eed9965425f1f832c7eca2dbea7057735a07"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
    assert_predicate testpath/"test_rodilius.jpg", :exist?
  end
end
