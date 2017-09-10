class Brainfuck < Formula
  desc "Interpreter for brainfuck written in C"
  homepage "https://github.com/fabianishere/brainfuck"
  url "https://github.com/fabianishere/brainfuck/archive/2.7.1.tar.gz"
  sha256 "06534de715dbc614f08407000c2ec6d497770069a2d7c84defd421b137313d71"
  head "https://github.com/fabianishere/brainfuck.git"

  option "with-debug", "Extend the interpreter with a debug command"
  option "with-examples", "Install brainfuck example programs"
  option "with-static-lib", "Build a static library"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DBUILD_SHARED_LIB=ON"
    args << "-DENABLE_DEBUG=ON" if build.with? "debug"
    args << "-DINSTALL_EXAMPLES=ON" if build.with? "examples"
    args << "-DBUILD_STATIC_LIB=OFF" if build.without? "static-lib"

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/brainfuck -e '++++++++[>++++++++<-]>+.+.+.'")
    assert_equal "ABC", output.chomp
  end
end
