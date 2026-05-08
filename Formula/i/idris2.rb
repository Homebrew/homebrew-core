class Idris2 < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris2/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "7b85226098c5dee96a0a77c892932d2e9fab8e5a5c2d08a0525520e1f4405551"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/idris-lang/Idris2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "45375bf663c6cdd730e3bd409bb4633cd36b8f69b252c688ab20eecfc29a5601"
    sha256 cellar: :any, arm64_sequoia: "0be20e6da1afbfccb8e71f76f7f4a6cddf5ee6928e942b780d150a7f4e9dfdb6"
    sha256 cellar: :any, arm64_sonoma:  "b1474603f8ef75f8cdb04b3ad423baf829169129844f4f0f1cf81e7c256173fd"
    sha256 cellar: :any, sonoma:        "3584c80942b2e441f6def91fd0d1ac33eefe74685986c98152b576339ec73bf3"
    sha256               arm64_linux:   "33223b4cfa733369263b45717d30aaa30a12907600328225bbd2e40d3caf1384"
    sha256               x86_64_linux:  "64a2f9e1eb7db689d9fd842cc779f1de91494a3856e9fd388ff5b1c41b4daf9f"
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
