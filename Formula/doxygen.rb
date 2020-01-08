class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  url "http://doxygen.nl/files/doxygen-1.8.17.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.17/doxygen-1.8.17.src.tar.gz"
  sha256 "2cba988af2d495541cbbe5541b3bee0ee11144dcb23a81eada19f5501fd8b599"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "93006f901963b40b8f5a2732c6955e8c21a4ef1146d6ee65848037ecf2d39178" => :mojave
    sha256 "512227291d4a0edcd18f183762fcc100b6d4c3960e55abe2ece5ab011f463316" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=#{MacOS.version}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
    end
    bin.install Dir["build/bin/*"]
    man1.install Dir["doc/*.1"]
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end
