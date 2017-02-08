class Fifechan < Formula
  desc "C++ GUI library designed for games"
  homepage "https://fifengine.github.io/fifechan/"
  url "https://github.com/fifengine/fifechan/archive/0.1.3.tar.gz"
  sha256 "66c07e030711ee7a8ef9bf583905de370d7972f22865c8a690fd3e710c626e5a"

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
