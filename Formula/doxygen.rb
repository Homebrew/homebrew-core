class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  url "https://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.12.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.12/doxygen-1.8.12.src.tar.gz"
  sha256 "792d4091cbdf228549ff2033dd71ff7ea5029c6b436317cc5ec866e71302df6c"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed81e27c7b251dda01c9d8f44657ed6508c12bb2f1703250fb40bbe9ff1392b1" => :sierra
    sha256 "60656bd148d8a143f6feda2ed4e61a910a62788ab5177864f9e19766546f32c0" => :el_capitan
    sha256 "9459c7ee8153939bd8ac152548d6c206d67a0aa16be2dcc61dcac616d652d019" => :yosemite
    sha256 "7bb03f81dc587296272560b6768f6088a5ef7846b9c4975ca6a1a05742393f20" => :mavericks
  end

  option "with-graphviz", "Build with dot command support from Graphviz."
  option "with-qt5", "Build GUI frontend with Qt support."
  option "with-llvm", "Build with libclang support."

  deprecated_option "with-dot" => "with-graphviz"
  deprecated_option "with-doxywizard" => "with-qt5"
  deprecated_option "with-libclang" => "with-llvm"

  depends_on "cmake" => :build
  depends_on "graphviz" => :optional
  depends_on "qt5" => :optional
  depends_on "llvm" => :optional

  def install
    args = std_cmake_args
    args << "-Dbuild_wizard=ON" if build.with? "qt5"
    args << "-Duse_libclang=ON -DLLVM_CONFIG=#{Formula["llvm"].opt_bin}/llvm-config" if build.with? "llvm"

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
