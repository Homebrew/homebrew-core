class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://primesieve.org/"
  url "https://github.com/kimwalisch/primesieve/archive/v6.4.tar.gz"
  sha256 "130040305c4b1fdd1a9177d5edd7f57d741a31e0f9b190d43aa85637534f4eed"

  bottle do
    cellar :any
    sha256 "52d1b86e7d5acd7d325c66be50c58a73764049926a3da652ab99435e0fae178a" => :high_sierra
    sha256 "6dde6731a301f71025fe7418034b8c28e69ade06554ae829df9d8d72a4c3ef31" => :sierra
    sha256 "eb0c474d43d660d8cfda7d80bd1c274286993bcd7036c8bfacbf21c9933c7ddc" => :el_capitan
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
