class Idris2 < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris2/archive/v0.5.1.tar.gz"
  sha256 "da44154f6eba5e22ec5ac64c6ba2c28d2df0a57cf620c5b00c11adb51dbda399"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/idris-lang/Idris2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 big_sur:      "39fe90502cd4a8a064b4f69bcc5b4e99295826cad363092b47d3353ed41db2da"
    sha256 cellar: :any,                 catalina:     "f29bcc24fc1a0581eb3f17823641c5444acc4df10e93c17eae573deab9a18fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fdd19a501c9b80da87fd4519ed43e9ed31647e17e03d582392d2b3d1517f7c74"
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
