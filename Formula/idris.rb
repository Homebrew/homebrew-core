require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.12.tar.gz"
  sha256 "dfc31dffd1bafd996a951cbcc551a69337f16a3fa5c2974ec872d62a38bd7c75"
  revision 1

  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "9dbdfd0a8d49247fa1bb9ba4fc4a7591eb4479dc0f340f5d4dc814fa73cc7002" => :el_capitan
    sha256 "04304a48eb29e806462e904c4f18d857ecc00953bc0a1f6a7d04c7022c61b5be" => :yosemite
    sha256 "19ec0259b661319c5ec12fc71c64de050305946bcd145161defff9d64fca43e4" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build

  depends_on "gmp"
  depends_on "libffi" => :recommended

  # GHC 8 compat
  # Adapted from upstream PR: https://github.com/idris-lang/Idris-dev/pull/3226
  # Fixes https://github.com/idris-lang/Idris-dev/issues/3193
  # Underlying GHC 8 issue: https://ghc.haskell.org/trac/ghc/ticket/12201
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/49941f6249e5b05dfd180abb4776f9e3a3bb25d8/idris/idris-ghc8.diff"
    sha256 "002e2b6d8392d451ecf0ddb37f181e3c87ed42ca0eee82cc4f8aba76e5e1cc11"
  end

  def install
    # GHC 8 compat for trifecta dependency; already fixed in trifecta HEAD
    (buildpath/"cabal.config").write("allow-newer: comonad,transformers\n")

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
