require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.99.2.tar.gz"
  sha256 "a4051d6783b15c8e25dd401f0f1984a0597db47f8373388cc04e60f76961b4eb"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "fd75cd3f7d38c3ce8b6e2a0df10625978590d92048197fe9b988e18a31ebbbf4" => :sierra
    sha256 "1b165401b176869142777f4f322031e80a4bbeb2f9afdf5eb031417467103503" => :el_capitan
    sha256 "3341be8de20ad197416bd5abaf5895c0a4ffc860dff72a608a826e9a1789a2a3" => :yosemite
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
