class Fifechan < Formula
  desc "C++ GUI library designed for games"
  homepage "https://fifengine.github.io/fifechan/"
  url "https://github.com/fifengine/fifechan/archive/0.1.4.tar.gz"
  sha256 "a93b015b5852b8fe2a0a2a6891d3de2cacb196732f670e081d7b7966f9ed1b87"

  bottle do
    cellar :any
    sha256 "f8c6e56c52bbf9028724e6ccd6faa9b2255be77c5036a2b4d55ec438a46306fa" => :sierra
    sha256 "6c006e2caa6b42b3f7a45413b2f92152d9b77867716042c9e699ea3b842f83b2" => :el_capitan
    sha256 "313863a1ce41d32f2318c4df87c58cf31a51e15ce48fddde391725fd511eecde" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "allegro" => :recommended
  depends_on "sdl" => :recommended
  depends_on "sdl_image" => :recommended

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"fifechan_test.cpp").write <<-EOS
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
