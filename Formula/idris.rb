require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.12.2.tar.gz"
  sha256 "6fc70db56113d3d5c3296df3e4982c6ddcf1ff636435378381600a093925400a"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "674f2574ac9e045976eb760ee869debaa9d931954666778208d6a9003a876515" => :el_capitan
    sha256 "58af65b746954978af25c6d3e54f49d4fffe5e8edaaf770852ec463b25201bba" => :yosemite
    sha256 "42aef44075917f0ebafaab1bf1980917a32e62ffe0f0cea38c6338dbdeba5343" => :mavericks
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
