require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris-dev/archive/v1.3.2.tar.gz"
  sha256 "48429b8ed80980f9a4d38c29e51fcbb51ea511640806cd3cb7752bfdbb4644d2"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "c7962cb3e053d2c7a076c1f2634ad3fc6fd2f81d48d2cca89271dddb962079f0" => :mojave
    sha256 "9824714173014b0f72a7e6446277805db9b89ea6c404a895ab4ce6ff3477fad0" => :high_sierra
    sha256 "dd3bfe19b49e43c06faad25eb55c233fadc5f16c73df137858c6f7dbd4dccbfc" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
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
