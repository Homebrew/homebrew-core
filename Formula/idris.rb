require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.11.2.tar.gz"
  sha256 "eddc8d8d6401d5c5743df43003a11d031be42eb6b09800dc1111606c39a3c8bc"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "6528a78528edb4c8d62447d5efcccc4754e69897938f28ce27ab222adab9cb45" => :el_capitan
    sha256 "725374c20e56df884f6332c9ecc6a75eb04bf1adb6c5b6db50c5c5c06d627031" => :yosemite
    sha256 "652da19c6f08b65483df86768813f6ce7eca2d8c31cf0a0f4f624a22344cdbef" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build if build.with? "libffi"

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

    (testpath/"ffi.idr").write <<-EOS.undent
      module Main
      puts: String -> IO ()
      puts x = foreign FFI_C "puts" (String -> IO ()) x

      main : IO ()
      main = puts "Hello, interpreter!"
    EOS
    shell_output "#{bin}/idris #{testpath}/hello.idr -o #{testpath}/hello"
    result = shell_output "#{testpath}/hello"
    assert_match /Hello, Homebrew!/, result

    if build.with? "libffi"
      shell_output "#{bin}/idris #{testpath}/ffi.idr -o #{testpath}/ffi"
      result = shell_output "#{testpath}/ffi"
      assert_match /Hello, interpreter!/, result
    end
  end
end
