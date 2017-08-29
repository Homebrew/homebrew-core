class Brainfuck < Formula
  desc "Interpreter for brainfuck written in C"
  homepage "https://github.com/fabianishere/brainfuck"
  url "https://github.com/fabianishere/brainfuck/archive/2.7.1.tar.gz"
  sha256 "528d57d823f3ee4bdcdc3315f99fed69d2e23aec34682fb6670d02f5dec0b40f"

  head "https://github.com/fabianishere/brainfuck.git"

  option "with-debug", "Compile interpreter with debug support"
  option "with-static-lib", "Build a static library"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DBUILD_SHARED_LIB=ON"
    args << "-DENABLE_DEBUG=ON" if build.with? "debug"

    system "cmake", ".", *args
    system "make"
    bin.install "brainfuck"
    man1.install "man/brainfuck.1"
    lib.install "libbrainfuck.dylib"
    if build.with? "static-lib"
      lib.install "libbrainfuck.a"
    else # upstream uses this static library in the build process
      rm "libbrainfuck.a"
    end
    pkgshare.install "examples"
  end

  test do
    system "#{bin}/brainfuck", "#{doc}/examples/hello.bf"
  end
end
