class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_99.tar.gz"
  sha256 "66ac4430367f2096466703b81749db836d8f4766e542b042d64e78b601372cf7"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "8fe6b20a333b303d522bcd5cd917c9fe4bfa0fa4f74b7eca27deb08a004b673b" => :big_sur
    sha256 "8223e06ab14ab31220ef1c8a394e9934230010ae71374ce42bb22aba318dbec5" => :arm64_big_sur
    sha256 "7b7b7e2d950825ec573b307fd4012dc05d981071958a3bf638b53fe4ac00d9ee" => :catalina
    sha256 "a09589993681168d076c3bfb62bf375585924e62f27f80deef20dcfedb306ce9" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

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
