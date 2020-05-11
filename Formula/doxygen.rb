class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.org/"
  url "https://doxygen.nl/files/doxygen-1.8.18.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.18/doxygen-1.8.18.src.tar.gz"
  sha256 "18173d9edc46d2d116c1f92a95d683ec76b6b4b45b817ac4f245bb1073d00656"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a9d0dcd889aba7e0e96fc62b1e5cce048adacbab03d3b924f9940b50c7b2d3c" => :catalina
    sha256 "ac54e6ace4d6167a03b7c0c8dbb956f696921eb32a5507e842227220852385df" => :mojave
    sha256 "630a2c57c428c9ae42d5d6f6f5986a08292db010c51f407c1bbb6224c4d9ddf7" => :high_sierra
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
