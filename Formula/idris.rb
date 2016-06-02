require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.11.2.tar.gz"
  sha256 "eddc8d8d6401d5c5743df43003a11d031be42eb6b09800dc1111606c39a3c8bc"
  revision 1
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "6528a78528edb4c8d62447d5efcccc4754e69897938f28ce27ab222adab9cb45" => :el_capitan
    sha256 "725374c20e56df884f6332c9ecc6a75eb04bf1adb6c5b6db50c5c5c06d627031" => :yosemite
    sha256 "652da19c6f08b65483df86768813f6ce7eca2d8c31cf0a0f4f624a22344cdbef" => :mavericks
  end

  depends_on "haskell-stack" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "libffi"

  def install
    ENV["STACK_ROOT"] = "#{HOMEBREW_CACHE}/stack_root"
    (libexec/"stack").install Dir["#{buildpath}/*"]

    cd libexec/"stack" do
      system "stack", "setup"
      system "stack", "build"

      bin.mkpath
      system "stack", "install", "--local-bin-path=#{bin}"

      install_dir = Utils.popen_read("stack", "path", "--local-install-root").chomp

      share.mkpath
      mv "#{install_dir}/share/man", share
      mv "#{install_dir}/doc", share

      libexec.install_symlink "#{install_dir}/lib"
      libexec.install_symlink "#{install_dir}/share"
    end
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
    system bin/"idris", testpath/"hello.idr", "-o", testpath/"hello"
    assert_match /Hello, Homebrew!/, shell_output(testpath/"hello")

    system bin/"idris", testpath/"ffi.idr", "-o", testpath/"ffi"
    assert_match /Hello, interpreter!/, shell_output(testpath/"ffi")
  end
end
