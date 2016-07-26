require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.12.1.tar.gz"
  sha256 "c3cabf16fcfad69f3d13e24e3426fd2335378a38387c69ceaeedd9cbf741f41b"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "88cb9901636a96b2800cb2e4145b2e2b729ec3963e441971609dd12d94a3253b" => :el_capitan
    sha256 "4f4f9d9be799412a7219bfe9363d915d22e5e953ed812aa8dc1ae8cecf4961fd" => :yosemite
    sha256 "bfaf0e0814007947916c3edd2187034dd23c7628341f096e97a8b8ec4088e820" => :mavericks
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
