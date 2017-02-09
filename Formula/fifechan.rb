class Fifechan < Formula
  desc "C++ GUI library designed for games"
  homepage "https://fifengine.github.io/fifechan/"
  url "https://github.com/fifengine/fifechan/archive/0.1.4.tar.gz"
  sha256 "a93b015b5852b8fe2a0a2a6891d3de2cacb196732f670e081d7b7966f9ed1b87"

  bottle do
    cellar :any
    sha256 "7e38fd0b6550b32cdb3482a5124957d67cd908bb2ebd186fdd0ca3e8558ea1da" => :sierra
    sha256 "4a23cb8fd1990af117c252b112c46a8dfa82563fc0df36e831f7cea822af1dab" => :el_capitan
    sha256 "1f30cc9ac8d56b0bf141e7499d2b8aa7f4f23078460e76c1fd239932a1a08fd9" => :yosemite
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
