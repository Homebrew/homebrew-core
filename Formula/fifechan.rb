class Fifechan < Formula
  desc "C++ GUI library designed for games"
  homepage "https://fifengine.github.io/fifechan/"
  url "https://github.com/fifengine/fifechan/archive/0.1.4.tar.gz"
  sha256 "a93b015b5852b8fe2a0a2a6891d3de2cacb196732f670e081d7b7966f9ed1b87"
  revision 1

  bottle do
    cellar :any
    sha256 "06da9e38eb6a8d87b29a73e14073a396b650057905589a185cc8e7935197e899" => :mojave
    sha256 "b3f6cd4d4da46b31b05065e92c0aa8159e809e4d6e9a17cb8f8a3d9abdf4a76a" => :high_sierra
    sha256 "357c467807ac368322803f4774441a8679983715efbe7ab2b89b22bbc4c03f1c" => :sierra
    sha256 "a12266c07e0109b9ad91c8747a25a2a0bb9469db382718f037d5a01175c8bad5" => :el_capitan
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
