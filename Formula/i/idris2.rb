class Idris2 < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris2/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "7b85226098c5dee96a0a77c892932d2e9fab8e5a5c2d08a0525520e1f4405551"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/idris-lang/Idris2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b24e19d4055957fccaacd37f3c43d091fd71083cb481e665bacb2e78ec2a4b1b"
    sha256 cellar: :any, arm64_sequoia: "c26756474e5e042aadd67188a4fe924b82e12537b7df11f872b9d744caf6d26d"
    sha256 cellar: :any, arm64_sonoma:  "e7e06b93ba0e65360832c4e173e99e8e3d229737e2145c45f6b41981117c983c"
    sha256 cellar: :any, sonoma:        "4da6358da95a555db8b23255ff05a400486d0766105adc71b776a605727a0dd0"
    sha256               arm64_linux:   "bd1c838fc77a473d01d9bfae5e310548e2904a77bc6cf454f846a6505694c5c5"
    sha256               x86_64_linux:  "2a3bf7dd15efa67287b47b5ee5f7befc999d6bc18ccf0c2b045b448260db2c02"
  end

  depends_on "gmp" => :build
  depends_on "chezscheme"

  def install
    scheme = Formula["chezscheme"].opt_bin/"chez"

    ENV.deparallelize
    ENV["CHEZ"] = scheme
    system "make", "bootstrap", "SCHEME=#{scheme}", "PREFIX=#{libexec}"
    system "make", "install", "PREFIX=#{libexec}"
    system "make", "install-with-src-libs", "PREFIX=#{libexec}"
    ENV.prepend_path "PATH", "#{libexec}/bin"
    system "make", "install-with-src-api", "PREFIX=#{libexec}"
    bin.install_symlink libexec/"bin/idris2"
    lib.install_symlink Dir[libexec/"lib"/shared_library("*")]
    generate_completions_from_executable(libexec/"bin/idris2", "--bash-completion-script", "idris2",
                                         shells: [:bash], shell_parameter_format: :none)
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
