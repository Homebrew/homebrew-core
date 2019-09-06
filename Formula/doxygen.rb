class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  url "http://doxygen.nl/files/doxygen-1.8.16.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.16/doxygen-1.8.16.src.tar.gz"
  sha256 "ff981fb6f5db4af9deb1dd0c0d9325e0f9ba807d17bd5750636595cf16da3c82"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "709545ed8f509c407d1a8ac2f36f396f783bd732c98ed18d79e57aa26e79fd74" => :mojave
    sha256 "882a5c055350590d2dfa31cbc786dab9760acfd222a05ecbabd7833cd09a66d9" => :high_sierra
    sha256 "5d002c6ee6d2619c5c5c9752c65537b81a135361f2c99f566a3e178de4f448f8" => :sierra
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
