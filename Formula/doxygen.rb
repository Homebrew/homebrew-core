class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.org/"
  url "https://doxygen.nl/files/doxygen-1.8.20.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.20/doxygen-1.8.20.src.tar.gz"
  sha256 "e0db6979286fd7ccd3a99af9f97397f2bae50532e4ecb312aa18862f8401ddec"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a4685d1a070c772799993261962da186a43d35bea7d0648c71e593878ca033a" => :catalina
    sha256 "975acd4d783e3d07f77d93bd8fa817eab4e192d297503494cb60dbc30880620c" => :mojave
    sha256 "6490b7d253d715a1210f87c1ba4ebb3a6a65d96d9802ce8760416cc09b1f36b3" => :high_sierra
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
