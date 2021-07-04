class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_101.tar.gz"
  sha256 "5d7cdec89957549f01b7c93f080d08827c87bbd4789a34694c740d15d077c041"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7c9f6e7464dd612d8fd5ecf97eb28be3a0e785807656971760355dbaee2ab308"
    sha256 cellar: :any, big_sur:       "b5b7f3d6275bcbb2497135dbaa92856172def96355c2e1c4dd3f6d11cbdd4f77"
    sha256 cellar: :any, catalina:      "3c1ec0bef52f4113e4898aec902fb3a631aa36b4ee82c4cbd9732357c5f6f79d"
    sha256 cellar: :any, mojave:        "d69a70807fee88c855c53594d135d358e9b51a4a7d9b50518c7ea09b0df76dc6"
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
