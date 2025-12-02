class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.11.1/allegro-5.2.11.1.tar.gz"
  sha256 "ab9582b3a8040cf4c086f4f1073dfe38b96fc3343a89b43765b892560437c7e0"
  license "Zlib"
  head "https://github.com/liballeg/allegro5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "08adde00369ca07ff74a0ca1d284b1b1728007c52ff93fce0a9c662848ad8f91"
    sha256 cellar: :any,                 arm64_sequoia: "014edc30f7d56fae5e705aa8a77139777c26c07c0d4ab67dfa8d6ba8e3e88425"
    sha256 cellar: :any,                 arm64_sonoma:  "df631f3ad7dfb6773249d09ceac3b75b3fab91d2923de8ea1f11724871998669"
    sha256 cellar: :any,                 sonoma:        "ead5ff1cf57077a034b4ae5f017fd63699e33ea4b6daa85262d0ab50cb289b0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f16c55411a28dbeb52fd76ba4d94c60f073ab76adaa7de48051e9d1cf11b4cdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44f09135d9cbba538ef3e819cb5883a13691bcc27fa1846a5246503397628f80"
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
