class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://primesieve.org/"
  url "https://github.com/kimwalisch/primesieve/archive/v7.2.tar.gz"
  sha256 "2bc7df5ad7fca4587dc5375d13627e1ef5501faafe579ee82b1e720baa02ad7b"

  bottle do
    cellar :any
    sha256 "97307fe0bc6fca6de51c859a7465440cdcf3ac2693b207e1f4be8fee11400023" => :mojave
    sha256 "42a7e92a2cd5a1e03ca160ff1a65084ac1f0bbfb61e8e4c56cffdfdc110a2d5a" => :high_sierra
    sha256 "3a3341cfa265da8eff8dd6fc8c1f52b826c26d6e585432db41cbde209cb30c85" => :sierra
    sha256 "7180bf9d8e18df23aadb480dad59840fce8f6a3bbc32a88c80bdaa80f370d6e3" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end
