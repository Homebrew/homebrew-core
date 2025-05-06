class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.10.1/allegro-5.2.10.1.tar.gz"
  sha256 "2ef9f77f0b19459ea2c7645cc4762fc35c74d3d297bfc38d8592307757166f05"
  license "Zlib"
  revision 1
  head "https://github.com/liballeg/allegro5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "db24d012cd88b23d8587898aceab3203169a995e7bc874e0db849942459ececa"
    sha256 cellar: :any,                 arm64_sonoma:  "871af04f1451b1064666dc3b696f810cb105fa4f0245125a61007d11d3210442"
    sha256 cellar: :any,                 arm64_ventura: "cc0ab101b41137fa5ea75ca65427c21e51164ad3ddd0af841816d068e932de97"
    sha256 cellar: :any,                 sonoma:        "0285e3c404d3351c218ed93958d982001a32092a6be106454772e5b981eebddb"
    sha256 cellar: :any,                 ventura:       "4b0d776e4d1539a4826a9e6eb721a9c769110cd33d20657d5ca1c870ff47c4da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b00b980e261ff3cab81d54a8952e7e46868c55c03bce69da9a38b0314d21298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77d8fa148090e9335b24c1bcd37d711c5206657ac0124c6dc7275e7c8f3e8da2"
  end

  depends_on "cmake" => :build
  depends_on "flac"
  depends_on "freetype"
  depends_on "libogg"
  depends_on "libopenmpt"
  depends_on "libvorbis"
  depends_on "opusfile"
  depends_on "physfs"
  depends_on "theora"
  depends_on "webp"

  on_macos do
    depends_on "opus"
  end

  on_linux do
    depends_on "jpeg-turbo"
    depends_on "libpng"
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "libxscrnsaver"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    cmake_args = %W[
      -DWANT_DOCS=OFF
      -DWANT_DUMB=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"allegro_test.cpp").write <<~CPP
      #include <assert.h>
      #include <allegro5/allegro5.h>

      int main(int n, char** c) {
        if (!al_init()) {
          return 1;
        }
        return 0;
      }
    CPP

    system ENV.cxx, "allegro_test.cpp", "-I#{include}", "-L#{lib}",
                    "-lallegro", "-lallegro_main", "-o", "allegro_test"
    system "./allegro_test"
  end
end
