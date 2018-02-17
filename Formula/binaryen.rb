class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "http://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_44.tar.gz"
  sha256 "ab02f0ae6900d06dff4d1c37c78f68e7d7bfecbdaceccd88d6a86ecd2b3b9d0c"

  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "56c0ad9fc87d9d6f836b53c6f376578c84603366a1d6b55f07982b36bcdc6bb5" => :high_sierra
    sha256 "02c4f8554f8956d31f22cba45de32af4c0d3ec489f84cc1e740b59109447373c" => :sierra
    sha256 "14b688abf43679334a7685350b93b9b90740fd97f8f5a21eaf96d016446cb804" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :macos => :el_capitan # needs thread-local storage

  needs :cxx11

  def install
    ENV.cxx11

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "#{pkgshare}/test/passes/O.wast"
    system "#{bin}/asm2wasm", "#{pkgshare}/test/hello_world.asm.js"
  end
end
