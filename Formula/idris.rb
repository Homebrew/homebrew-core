require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris-dev/archive/v1.3.3.tar.gz"
  sha256 "ad693614cc61a92bf51a33f5dc74f90b2eba91fd89064ec0580525e220556113"
  license "BSD-3-Clause"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "21957bdad1ae76da84a7bce2600eb8ee04e4237f5d2e207f9d17c1a36dcc0dfc" => :catalina
    sha256 "34176d383858ef2eafc782a933625de1ad555d4c9d8c5c2f8153baf586b0a0ae" => :mojave
    sha256 "8fa79b9a1e987385e64432dac32a619a654b934bce8f0e42217f579bb43580ad" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build # 8.8 will be supported in the next release
  depends_on "pkg-config" => :build
  depends_on "libffi"

  def install
    args = ["-f", "FFI"]
    args << "-f" << "release" if build.stable?
    install_cabal_package(*args)
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
