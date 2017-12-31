class Pocl < Formula
  desc "MIT-licensed open source implementation of the OpenCL standard"
  homepage "http://portablecl.org/"
  url "http://portablecl.org/downloads/pocl-1.0.tar.gz"
  sha256 "94bd86a2f9847c03e6c3bf8dca12af3734f8b272ffeacbc3fa8fcca58844b1d4"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  # POCL 1.0 does not support LLVM 6
  depends_on "llvm@5"

  depends_on "hwloc"
  depends_on "libtool"

  option "without-test", "Skip build-time tests (not recommended)"
  
  def install
    cmake_args = std_cmake_args
    cmake_args << "-DWITH_LLVM_CONFIG=#{Formula["llvm@5"].opt_bin}/llvm-config"
    cmake_args << "-DCMAKE_FIND_FRAMEWORK=NEVER" # Preventing LTDL_H been set to Mono's include path
    system "cmake", ".", *cmake_args
    system "make"
    # system "make", "check" if build.with? "test" # Disable for now due to https://github.com/pocl/pocl/issues/412
    system "make", "install"
  end
end
