class Fifechan < Formula
  desc "C++ GUI library designed for games"
  homepage "https://fifengine.github.io/fifechan/"
  url "https://github.com/fifengine/fifechan/archive/0.1.3.tar.gz"
  sha256 "66c07e030711ee7a8ef9bf583905de370d7972f22865c8a690fd3e710c626e5a"

  bottle do
    cellar :any
    sha256 "5d9d9cca51acebbab4e5fa4273d1c0825590ed38c725ebdf9edeb174229a07b1" => :sierra
    sha256 "799e8fa5def1592ff559ed13913b0aff53b0df8fba9c8b2e46ed4af0800bbf20" => :el_capitan
    sha256 "8eeeaad4b2d4d95573417b2a2a42dc2199d1148033011fab4a7854b0bf11542f" => :yosemite
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
