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
    sha256 cellar: :any,                 arm64_sonoma:   "c7950e786cf3df37885e03a4dcaf3d629ee65cbd8c161bc136f0fea34550e53a"
    sha256 cellar: :any,                 arm64_ventura:  "cd5a0596a4bbff5d07ac6f3062f725f8b31df587daff52613f5574000655f634"
    sha256 cellar: :any,                 arm64_monterey: "c0a18f1f2732b4e65760550720c82dc86b81f0ded91470bd9fb075644ceda371"
    sha256 cellar: :any,                 sonoma:         "cfacf7b33e5376d48c65b647b0ed241ae048a82cece3bbf30c43cc2a28438119"
    sha256 cellar: :any,                 ventura:        "b39af451958761b3f916406756c48199f315cbd0e66d5ad92b42b5a50e1b4173"
    sha256 cellar: :any,                 monterey:       "ba645c7fd58e6f6228e2b553461068daa509136749370d95d62a0f5200a7dbf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8839e691ba0a19e8c0b1220520b91bb1a1eeb3a560e7911b1784bf4085025edd"
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

  on_linux do
    depends_on "jpeg-turbo"
    depends_on "libpng"
    depends_on "libx11"
    depends_on "libxcursor"
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
