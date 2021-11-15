class Idris < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris-dev/archive/v1.3.4.tar.gz"
  sha256 "7289f5e2501b7a543d81035252ca9714003f834f58b558f45a16427a3c926c0f"
  license "BSD-3-Clause"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 monterey: "704add14a985699c70650b364a9069f1a2b4ad52f9238890067d695744db63e4"
    sha256 big_sur:  "19ad0c1b5aed35799c1a7199418e96b509b19b5fdad8dcf6492ca0ec10b14676"
    sha256 catalina: "c38a0f42b48ace8818f060ed26834d9e395e614f12fe6449b1e48513c73dcec8"
  end

  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "ghc@8.8"
  depends_on "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "--storedir=#{libexec}", "v2-install", *std_cabal_v2_args
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
