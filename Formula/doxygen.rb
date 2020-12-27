class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.org/"
  url "https://doxygen.nl/files/doxygen-1.9.0.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.0/doxygen-1.9.0.src.tar.gz"
  sha256 "636bab2c3c85603302600ed9b95425717aee776e56a3215325fcce15bbfdaef6"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc3669baeb52ada88bfa9de532187fbd6efe98fa3b6ccef1e9e42eb0eabcf417" => :big_sur
    sha256 "b04343c08ad3dc103f695cfa1710fbee38b59f7a85f592c846d2b022926779a1" => :arm64_big_sur
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
