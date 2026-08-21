class Fifechan < Formula
  desc "C++ GUI library designed for games"
  homepage "https://fifengine.github.io/fifechan/"
  url "https://github.com/fifengine/fifechan/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "8295ba2f2988f13f7c574cbc53eb1d30bc35ea78c79e53c2728ca23e30635425"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d2fe502b6de6f822f394a4287b0579c50c4bccc81d8b0d44753e111dea35d3ac"
    sha256 cellar: :any,                 arm64_sequoia: "3c4ca83c13a2952eca7fa7aa5d18df1b572413fa7ab1972cf95f2aebb9a99c6d"
    sha256 cellar: :any,                 arm64_sonoma:  "1e45b4fdff8986a6413f001ae8c04a377103a9a788120dcb1c4c4287c0c35ecc"
    sha256 cellar: :any,                 sonoma:        "e4e6aacbe86bc0513cc804c67d1b95109dd6c7682165a597352ed8fbeece93b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6bdae04454c0c7cd0f8bb94a90e8b1e884bb8802fb2d5e593728b3f52f3fdc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0062d1190d4640cd4b8cd0181817fad98330da448db762477690994594b5660c"
  end

  depends_on "cmake" => :build
  depends_on "utf8cpp" => :build
  depends_on "allegro"
  depends_on "freetype"
  depends_on "sdl3"
  depends_on "sdl3_image"
  depends_on "sdl3_ttf"

  on_linux do
    depends_on "mesa"
  end

  def install
    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DUSE_VCPKG=OFF
      -DFIFEGUI_EXAMPLES=OFF
      -DFIFEGUI_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"fifechan_test.cpp").write <<~CPP
      #include <fifechan.hpp>
      int main(int n, char** c) {
        fcn::Container* mContainer = new fcn::Container();
        if (mContainer == nullptr) {
          return 1;
        }
        return 0;
      }
    CPP

    system ENV.cxx, "fifechan_test.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-lfifechan", "-o", "fifechan_test"
    system "./fifechan_test"
  end
end
