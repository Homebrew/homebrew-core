class Fifechan < Formula
  desc "C++ GUI library designed for games"
  homepage "https://fifengine.github.io/fifechan/"
  url "https://github.com/fifengine/fifechan/archive/0.1.5.tar.gz"
  sha256 "29be5ff4b379e2fc4f88ef7d8bc172342130dd3e77a3061f64c8a75efe4eba73"
  license "LGPL-2.1"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "9803b9f51bc0c0d368baaf0dfcf1bd1694426b1ed0fee2e247835b49fa62f3ec" => :big_sur
    sha256 "73f4cff07f6b17373b6c3c94734aa26de09a5cf6c9ec25e92b35d66c605ba728" => :arm64_big_sur
    sha256 "c0594d877411b0a33f2a37d0d3e2ca38a3d3dfd47797bf89aef9579bd2095dda" => :catalina
    sha256 "93491cce22fd712b86ec6f7af129107a596f2e736181354417c4d48c0c40b919" => :mojave
    sha256 "725c25c62dd609dd58d19c25b484398e9e68f19a9cb7aa3c1d1877b53ed9615a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "allegro"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_ttf"

  def install
    mkdir "build" do
      system "cmake", "..", "-DENABLE_SDL_CONTRIB=ON", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"fifechan_test.cpp").write <<~EOS
      #include <fifechan.hpp>
      int main(int n, char** c) {
        fcn::Container* mContainer = new fcn::Container();
        if (mContainer == nullptr) {
          return 1;
        }
        return 0;
      }
    EOS

    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lfifechan", "-o", "fifechan_test", "fifechan_test.cpp"
    system "./fifechan_test"
  end
end
