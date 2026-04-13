class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.11.3/allegro-5.2.11.3.tar.gz"
  sha256 "aba4679a5b1f2bf62482eba6e8814a94de7ffc86de5f8587ba199fcc61b4a04f"
  license "Zlib"
  head "https://github.com/liballeg/allegro5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3e3538d2dd7ac9ab3c79343acec0f77a2746a50a6435371dfc35a75715aba9b"
    sha256 cellar: :any,                 arm64_sequoia: "8c04e595d03638289223bedd1696bacd8df8530f1a55721b3682af08c198a603"
    sha256 cellar: :any,                 arm64_sonoma:  "5da777e9838c3f86978a15ea5359b928123e70d32ca7ac43670631f17e85458b"
    sha256 cellar: :any,                 sonoma:        "1e0c9fe820bf392ee0707eff299fe523ebbd6e21d1327714f5c3ac36a53f3df7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70dbfd0353c0655b5a6bfe5520fabe067e17e423a209465b435cc067b1eec6bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ae31e6b786d07b263625a5c9d6ac16e77749a438492d9a8cf69a00e9be4b5ac"
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
