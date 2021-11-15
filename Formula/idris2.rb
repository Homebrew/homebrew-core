class Idris2 < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris2/archive/v0.5.1.tar.gz"
  sha256 "da44154f6eba5e22ec5ac64c6ba2c28d2df0a57cf620c5b00c11adb51dbda399"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/idris-lang/Idris2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 big_sur:      "bd0fe93d2cf1992c825305e9fbc451cc900aacd15e5d2fcf8ca9a14c1abc9385"
    sha256 cellar: :any,                 catalina:     "9a677678a11af3aa67e96cc31592b6690cbaa801fb16200f019e04ef582c8815"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "abf8255278b85d80ba3e41759c8df2a3d7a95ebd278a8fae24c19bda9f45e207"
  end

  depends_on "coreutils" => :build
  depends_on "gmp" => :build
  depends_on "chezscheme"
  uses_from_macos "zsh" => :build, since: :mojave

  def install
    ENV.deparallelize
    scheme = Formula["chezscheme"].bin/"chez"
    system "make", "bootstrap", "SCHEME=#{scheme}", "PREFIX=#{libexec}"
    system "make", "install", "PREFIX=#{libexec}"
    bin.install_symlink libexec/"bin/idris2"
    lib.install_symlink Dir["#{libexec}/lib/#{shared_library("*")}"]
    (bash_completion/"idris2").write Utils.safe_popen_read(bin/"idris2", "--bash-completion-script", "idris2")
  end

  test do
    (testpath/"hello.idr").write <<~EOS
      module Main
      main : IO ()
      main =
        let myBigNumber = (the Integer 18446744073709551615 + 1) in
        putStrLn $ "Hello, Homebrew! This is a big number: " ++ ( show $ myBigNumber )
    EOS

    system bin/"idris2", "hello.idr", "-o", "hello"
    assert_equal "Hello, Homebrew! This is a big number: 18446744073709551616",
                 shell_output("./build/exec/hello").chomp
  end
end
