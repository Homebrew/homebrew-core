class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_101.tar.gz"
  sha256 "5d7cdec89957549f01b7c93f080d08827c87bbd4789a34694c740d15d077c041"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "56165cbe52e86afde8f5030d13c60885f1e3a98013d81ae294f93b06e92c5da1"
    sha256 cellar: :any, big_sur:       "6ec130eba9a753aeef345c1521613a950bc703943c86685a9eca97db367d29b0"
    sha256 cellar: :any, catalina:      "8843e1dd958ab41d475afda03b3b27e62ea791d0bb7c515ee5b9804429c5c6f0"
    sha256 cellar: :any, mojave:        "096b306c87fcb4b8c5e566bca323f9087ad04984c5aa36e51cfa90bc919bc512"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "-O", "#{pkgshare}/test/passes/O.wast", "-o", "1.wast"
  end
end
