class Brainfuck < Formula
  desc "Interpreter for the brainfuck language"
  homepage "https://github.com/fabianishere/brainfuck"
  url "https://github.com/fabianishere/brainfuck/archive/2.7.1.tar.gz"
  sha256 "06534de715dbc614f08407000c2ec6d497770069a2d7c84defd421b137313d71"
  head "https://github.com/fabianishere/brainfuck.git"

  option "with-debug", "Extend the interpreter with a debug command"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %w[-DBUILD_SHARED_LIB=ON -DBUILD_STATIC_LIB=ON -DINSTALL_EXAMPLES=ON]
    args << "-DENABLE_DEBUG=ON" if build.with? "debug"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/brainfuck -e '++++++++[>++++++++<-]>+.+.+.'")
    assert_equal "ABC", output.chomp
  end
end
