class Latino < Formula
  desc "Lenguaje de programación de código abierto para latinos y de habla hispana"
  homepage "https://www.lenguajelatino.org/"
  license "MIT"
  stable do
    url "https://github.com/lenguaje-latino/Latino/archive/v1.3.0.tar.gz"
    sha256 "28118a047265394ad9a5fcb2c76895d08af4b43a5886f52afce98a0f8cdc86fe"
    depends_on "cmake" => :build
    depends_on "make" => :build
  end
  head do
    url "https://github.com/lenguaje-latino/Latino.git"
    depends_on "cmake" => :build
    depends_on "make" => :build
  end
  fails_with :clang do
    build 600
    cause "multiple configure and compile errors"
  end
  fails_with :gcc do
    build 600
    cause "multiple configure and compile errors"
  end
  def install
    mv "logo/Latino-logo.png", "logo/desktop.png"
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
  test do
    system bin/"latino", "-v"
  end
end
