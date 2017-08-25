class Brainfuck < Formula
  desc "Interpreter for brainfuck written in C."
  homepage "https://github.com/fabianishere/brainfuck"
  url "https://github.com/fabianishere/brainfuck/archive/2.7.0.tar.gz"
  sha256 "aaa14203aeece4e9627c8eb707c5c630020d22a6d4465c35595dbbc854ddddd7"
  head "https://github.com/fabianishere/brainfuck.git"

  option "with-debug", "Compile interpreter with debug support"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DENABLE_DEBUG=ON" if build.with? "debug"

    system "cmake", ".", *args
    system "make"
    bin.install "brainfuck"
    man1.install "man/brainfuck.1"
    lib.install "libbrainfuck.a"
    doc.install "examples"
  end

  test do
    system "#{bin}/brainfuck | cat"
  end
end
