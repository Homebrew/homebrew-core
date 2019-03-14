class Fifechan < Formula
  desc "C++ GUI library designed for games"
  homepage "https://fifengine.github.io/fifechan/"
  url "https://github.com/fifengine/fifechan/archive/0.1.5.tar.gz"
  sha256 "29be5ff4b379e2fc4f88ef7d8bc172342130dd3e77a3061f64c8a75efe4eba73"

  bottle do
    cellar :any
    sha256 "5937aa4c53237b058dda1132fe52cb170edc885c553c0137c8f65cc969e34670" => :mojave
    sha256 "212bf8bc5c6fc69aab9c0c155e6555e5e104031a60352e5890a948c40f5547af" => :high_sierra
    sha256 "67ef643758003a8f58eaf26fe3955542d90304c5371fa634da0137b2223ca7aa" => :sierra
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
