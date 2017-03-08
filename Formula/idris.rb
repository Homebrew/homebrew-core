require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.99.1.tar.gz"
  sha256 "0e0ba94f1e6f7b154f5dc41fc41cc0736724a79600156558c0d04c582476b288"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "de91c5675866f4f9e125d570f129d81725d838624e7a5fcd714b1fbd8f2c41d6" => :sierra
    sha256 "17513dc87747cd33a961139b9a2f1da8ac220367339dfafdbacadc0c315f690d" => :el_capitan
    sha256 "368321d8587de73e454cd10e22a258f87ded1f2d18d6b97671bcfa310d0fe05b" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build

  depends_on "gmp"
  depends_on "libffi" => :recommended

  def install
    args = []
    args << "-f FFI" if build.with? "libffi"
    args << "-f release" if build.stable?
    install_cabal_package *args
  end

  test do
    (testpath/"hello.idr").write <<-EOS.undent
      module Main
      main : IO ()
      main = putStrLn "Hello, Homebrew!"
    EOS

    system bin/"idris", "hello.idr", "-o", "hello"
    assert_equal "Hello, Homebrew!", shell_output("./hello").chomp

    if build.with? "libffi"
      (testpath/"ffi.idr").write <<-EOS.undent
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
end
