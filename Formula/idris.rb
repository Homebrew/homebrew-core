require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.12.tar.gz"
  sha256 "dfc31dffd1bafd996a951cbcc551a69337f16a3fa5c2974ec872d62a38bd7c75"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "9dbdfd0a8d49247fa1bb9ba4fc4a7591eb4479dc0f340f5d4dc814fa73cc7002" => :el_capitan
    sha256 "04304a48eb29e806462e904c4f18d857ecc00953bc0a1f6a7d04c7022c61b5be" => :yosemite
    sha256 "19ec0259b661319c5ec12fc71c64de050305946bcd145161defff9d64fca43e4" => :mavericks
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
