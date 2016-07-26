require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.12.1.tar.gz"
  sha256 "c3cabf16fcfad69f3d13e24e3426fd2335378a38387c69ceaeedd9cbf741f41b"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "a3cef862290754f51d28d481fdd3a6e8d5a4e91c40da210de7e6d45e333fb6e6" => :el_capitan
    sha256 "3f35d78aeafc5c9bd4e09d20ab3e3b3ee649b077ecc8d70febf3de5fa38de8af" => :yosemite
    sha256 "2e7daa523cb0d124938fe25416fedc5b081156799539dd87e6e8ef5d20138abd" => :mavericks
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
