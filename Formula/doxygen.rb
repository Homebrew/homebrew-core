class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  url "https://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.14.src.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/doxygen/doxygen_1.8.14.orig.tar.gz"
  sha256 "d1757e02755ef6f56fd45f1f4398598b920381948d6fcfa58f5ca6aa56f59d4d"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c5173aa74ee4c609a11ce80ecf26588dc5f682356c382fe833960f91e386476e" => :high_sierra
    sha256 "a5e7436a64a38db42f85d8f48c683423288933d61e7607b82883388c73a8a724" => :sierra
    sha256 "d42d176ead71b9276a1f55d13936132fd51627ceec4ab309de3abb79def891a1" => :el_capitan
    sha256 "215437e6278729e060526ada23b9e2c75eb93028269c4613610b9391b8976c81" => :yosemite
  end

  option "with-graphviz", "Build with dot command support from Graphviz."
  option "with-qt", "Build GUI frontend with Qt support."
  option "with-llvm", "Build with libclang support."

  deprecated_option "with-dot" => "with-graphviz"
  deprecated_option "with-doxywizard" => "with-qt"
  deprecated_option "with-libclang" => "with-llvm"
  deprecated_option "with-qt5" => "with-qt"

  depends_on "cmake" => :build
  depends_on "graphviz" => :optional
  depends_on "qt" => :optional
  depends_on "llvm" => :optional

  def install
    args = std_cmake_args << "-DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=#{MacOS.version}"
    args << "-Dbuild_wizard=ON" if build.with? "qt"
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
