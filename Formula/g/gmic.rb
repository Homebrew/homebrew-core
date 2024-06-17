class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.4.0.tar.gz"
  sha256 "4fc0c79eed360c4f804d8110d7955bc8e0db9a14fba9483fe494f02c3640be69"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2aff00789d67f96ac9769c7db736edc894d67299a951e4163184b08867c5eea8"
    sha256 cellar: :any,                 arm64_ventura:  "1a763350b3103aa9c6082e2f8fd22ef9b10f41b9e05da970b2d703f75caab062"
    sha256 cellar: :any,                 arm64_monterey: "0c018c3c576b2301a5a9de92c42950c5a28230b39c7501b4e5a87426485b48ba"
    sha256 cellar: :any,                 sonoma:         "d5a768c488dc8ff9bdbb58a5e66169f239324599f1275d9164b86bf9f010ffb5"
    sha256 cellar: :any,                 ventura:        "6990dd996965abe8c986629a932e313ad0173cfe860aaccb057485c0b50ec631"
    sha256 cellar: :any,                 monterey:       "153dc171edb149ad53761203c5c781d4613fe4bf42c9b9885f063fcc8249dd89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4475048a21c9d904eb07fc4243a93ed25726a0960022a12d146b183965d46ea"
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
