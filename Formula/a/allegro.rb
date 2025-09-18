class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.10.1/allegro-5.2.10.1.tar.gz"
  sha256 "2ef9f77f0b19459ea2c7645cc4762fc35c74d3d297bfc38d8592307757166f05"
  license "Zlib"
  revision 2
  head "https://github.com/liballeg/allegro5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "279a66b4096e22b8b252632d8daf3f83e1c378a7d470699ffebda7e779be9db8"
    sha256 cellar: :any,                 arm64_sequoia: "b5a0bac3386f3bce78af4bf6e938a21bd329178d7055dd811f33ea8299a916d9"
    sha256 cellar: :any,                 arm64_sonoma:  "c09db091d2391cd5cb51e00e4857ceabdf279ebcc111fd501b1331dd990ad091"
    sha256 cellar: :any,                 arm64_ventura: "a72784c6d7f9dad5f653e8d16e20e12c9f4d718494003e2efe12bd9e4dc9377e"
    sha256 cellar: :any,                 sonoma:        "04e6776435cf05f3dbedddb3eae6124ba1fe4eb0438b3e7b6816633e95890867"
    sha256 cellar: :any,                 ventura:       "43ced1b768c9fb07f4cb012b0898c91d464d52aaac253dc5e337494b83d3ce1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "421fc43dcbb28fc51af56b84ed76d0a3febaed1f931ea05c6a47873797c63118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f4d4bd8e8e01b35aca70053f1fc651c35a9ed2c37bab958aeb2b833e6b02044"
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
