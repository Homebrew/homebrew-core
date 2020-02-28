require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris-dev/archive/v1.3.2.tar.gz"
  sha256 "48429b8ed80980f9a4d38c29e51fcbb51ea511640806cd3cb7752bfdbb4644d2"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "2b3108c6e19675138e12ea5a3056c5d29d3abba503367333070fd68c94cd9253" => :mojave
    sha256 "8dba0d753d7f4abc9e5289cc3247be93ae7f3bd2f3f630b02f9b1dbe7b23c240" => :high_sierra
    sha256 "1830f2619e1497e8fff33ad94d23704410e52fbaf5a8b6062e2053f939961477" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build # 8.8 will be supported in the next release
  depends_on "pkg-config" => :build
  depends_on "libffi"

  def install
    args = ["-f", "FFI"]
    args << "-f" << "release" if build.stable?
    install_cabal_package *args
  end

  test do
    (testpath/"hello.idr").write <<~EOS
      module Main
      main : IO ()
      main = putStrLn "Hello, Homebrew!"
    EOS

    system bin/"idris", "hello.idr", "-o", "hello"
    assert_equal "Hello, Homebrew!", shell_output("./hello").chomp

    (testpath/"ffi.idr").write <<~EOS
      module Main
      puts: String -> IO ()
      puts x = foreign FFI_C "puts" (String -> IO ()) x
      main : IO ()
      main = puts "Hello, interpreter!"
    EOS

    system bin/"idris", "ffi.idr", "-o", "ffi"
    assert_equal "Hello, interpreter!", shell_output("./ffi").chomp
  end
end
