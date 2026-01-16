class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.11.2/allegro-5.2.11.2.tar.gz"
  sha256 "f035fe128dd5f2412c32add41ed4058ad8154f6e9571084574487d67dbdbaae0"
  license "Zlib"
  head "https://github.com/liballeg/allegro5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ad681765153acc0fda4da580cc3ba66de27645bbd74e3c252b2a1e0609226652"
    sha256 cellar: :any,                 arm64_sequoia: "35d5fbb95eb7695c2d85e080680802f621adcaa3d34a75f194fb24d5e067ceb5"
    sha256 cellar: :any,                 arm64_sonoma:  "32e4ccc2d808520adfe38e38c02839a53cda33863bc23aa9cdc1422cc9e7eb6a"
    sha256 cellar: :any,                 sonoma:        "42cb8a1c25c9757b841925fb203ab6b71a27b9f6d5a1d025db24b449cf6a3ffa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2cb54616a1922c3db8e113d507a6f579705ef135dd85b35943e579d3c9fe9bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f99597861da48d4bbef543da329c05378c5543611805bbade3835f59378c365"
  end

  depends_on "cmake" => :build
  depends_on "flac"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libogg"
  depends_on "libopenmpt"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "opusfile"
  depends_on "physfs"
  depends_on "theora"
  depends_on "webp"

  on_macos do
    depends_on "opus"
  end

  on_linux do
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
