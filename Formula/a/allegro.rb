class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.10.1/allegro-5.2.10.1.tar.gz"
  sha256 "2ef9f77f0b19459ea2c7645cc4762fc35c74d3d297bfc38d8592307757166f05"
  license "Zlib"
  head "https://github.com/liballeg/allegro5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "79f3b5c3b0bd394ed78f59d83c0c600bab8a40de1048dfba4044addb8ce84e48"
    sha256 cellar: :any,                 arm64_sonoma:  "0bff19547f67acd417d503ffa601c4abbc1c0677018383608f74231bed2181e1"
    sha256 cellar: :any,                 arm64_ventura: "aa3dea47c0887752b899daed2e4d672094a197c321e4c2dc21dbb1f6d299b3ee"
    sha256 cellar: :any,                 sonoma:        "165885c74f91990ba86bacdd0b27e655e51e3a1c628b3b9dde8e8b17a890fca4"
    sha256 cellar: :any,                 ventura:       "1357c95194e2a91e4520515c8730067a0cd22606e7717f8923266c4cdd3437c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f335668957c66cd3f4a6151af0b45cc19e0b1963d9fc304711907237f5e49c76"
  end

  depends_on "cmake" => :build
  depends_on "dumb"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libogg"
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
    cmake_args = std_cmake_args + %W[
      -DWANT_DOCS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args
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
