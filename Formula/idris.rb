class Idris < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris-dev/archive/v1.3.4.tar.gz"
  sha256 "7289f5e2501b7a543d81035252ca9714003f834f58b558f45a16427a3c926c0f"
  license "BSD-3-Clause"
  head "https://github.com/idris-lang/Idris-dev.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "445fd6dc56bf3e6db6bbc3fabca8631a95ebeadf9dba1d3df2237bfb9c030492"
    sha256 arm64_big_sur:  "5eb72d95ae07a2d7da0bf9c56c152a35ae57f41222da5c47661b3df0a1823a5a"
    sha256 monterey:       "30b22c6d78dda77313fc42e959a0ef42b072f4517ed9e2aa5aeba57e9c51030c"
    sha256 big_sur:        "5683f5a66b71affbf7ae4772e95ed5ef594c9b494c255c2aa09943a8436dab62"
    sha256 catalina:       "01e7e70d851df23dda11b9a7cc16bfd4e9b946ea4d57824b78f78e2e484b5824"
    sha256 x86_64_linux:   "ace178397055df3f7427278c940e27121236e02a5a5eff504bc10ca330411189"
  end

  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "ghc@8.10"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
