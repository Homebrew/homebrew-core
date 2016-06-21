require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.12.tar.gz"
  sha256 "dfc31dffd1bafd996a951cbcc551a69337f16a3fa5c2974ec872d62a38bd7c75"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "ef4de83fa2e754bc7730a6e79e4e7be548e47713790573804465ec84ef6b96de" => :el_capitan
    sha256 "233838359600772f282b90030147b6cdb78ebceb95a7c7c85e9a0b81d8413ac5" => :yosemite
    sha256 "0f949e2fd727d9c73575c6ea002048057440472fc916435ee542232461ea2485" => :mavericks
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
