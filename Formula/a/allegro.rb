class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.9.1/allegro-5.2.9.1.tar.gz"
  sha256 "0ee3fc22ae74601ad36c70afd793ff062f0f7187eeb6e78f8a24e5bf69170d30"
  license "Zlib"
  head "https://github.com/liballeg/allegro5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e7cb14592b50dd4cecf96f955fc51cdd42971d10beb3d3c3916177fe49abdc20"
    sha256 cellar: :any,                 arm64_sonoma:   "b97f4ec79c8d719f8fbdc13ba2f8a22ccccffe0f2018b24a1e07da97d0f9b657"
    sha256 cellar: :any,                 arm64_ventura:  "aa6bb7451473ddcdd561b18320ab796b8b49da42298051d4cc3296bac2bdd1a2"
    sha256 cellar: :any,                 arm64_monterey: "519864e5f46d08950e520c5b6e78a2862870bb75c104fa39f49d23b03d3e12e7"
    sha256 cellar: :any,                 sonoma:         "220a11469f57805a841c694e01c4380cace79d824763f87ae020f9d417478b8f"
    sha256 cellar: :any,                 ventura:        "2f313c856da22770699bf8aa80995a5df7f07b0bf62f36166647e001ca925dfd"
    sha256 cellar: :any,                 monterey:       "f8c47be9eb80f02a1cfdd6d2bba2a148a6794542fc3941861389dce011bcb3b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee72b21114fea150045e575b6ab3db8ab7332deb7499d25d284e776c9a367a4b"
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

  fails_with gcc: "5"

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
    (testpath/"allegro_test.cpp").write <<~EOS
      #include <assert.h>
      #include <allegro5/allegro5.h>

      int main(int n, char** c) {
        if (!al_init()) {
          return 1;
        }
        return 0;
      }
    EOS

    system ENV.cxx, "allegro_test.cpp", "-I#{include}", "-L#{lib}",
                    "-lallegro", "-lallegro_main", "-o", "allegro_test"
    system "./allegro_test"
  end
end
