class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.org/"
  url "https://doxygen.nl/files/doxygen-1.8.19.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.19/doxygen-1.8.19.src.tar.gz"
  sha256 "ac15d111615251ec53d3f0e54ac89c9d707538f488be57184245adef057778d3"
  license "GPL-2.0"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb5dc54b77c0c510e7242e37bc54828569ee2c976ea08245b99abfa4021b6cf7" => :catalina
    sha256 "3be27666e048b1b7eb74f8194d3d869b4eab56d4373e056b629ef03030ca81ed" => :mojave
    sha256 "4b35de197efeef2f7b673d63865bc2c60da76b1d9485d19d64fd633d4ce42fb8" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
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
