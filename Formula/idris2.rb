class Idris2 < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris2/archive/v0.4.0.tar.gz"
  sha256 "e06fb4f59838ca9da286ae3aecfeeeacb8e85afeb2e2136b4b751e06325f95fe"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/idris-lang/Idris2.git"

  bottle do
    sha256 cellar: :any, big_sur:  "e323eab293f27d82f14b3ab5e68023db2cbaca8d26b911d96a7c7d8971d44b53"
    sha256 cellar: :any, catalina: "5919c36d63f78921d94062b46927e7dd6ae52ea6c5318b599e9522d28b1cc243"
    sha256 cellar: :any, mojave:   "847646c54f71dea739dfb24e167c41d8a14c9c02e1f6d08fa639d5a468c6d4cf"
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
