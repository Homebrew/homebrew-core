class Idris2 < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris2/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "7b85226098c5dee96a0a77c892932d2e9fab8e5a5c2d08a0525520e1f4405551"
  license "BSD-3-Clause"
  head "https://github.com/idris-lang/Idris2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "768acb8421fcfde56de83b7f36637ab31189a939bab606cb6084b04a2e63ec3e"
    sha256 cellar: :any, arm64_sequoia: "05546943e537df2312e319a916b217a3e0683c353cb1dce499692c5250220201"
    sha256 cellar: :any, arm64_sonoma:  "e31df26bcafb55dc49d8e547543981045a7f86d4bd9d8132bdf5eeb538147f52"
    sha256 cellar: :any, sonoma:        "9239b97ee3e0176d9d016f4dc1e194f0e25251bf403aa37776bac289092dcda3"
    sha256               arm64_linux:   "d26d06c4c596187bf494e48afe507e9d036db5d5ba7d7de91c159fb661619dc5"
    sha256               x86_64_linux:  "69e8edc3851beb8bfbd130453a8cb49831e443d7f16702c063cfae3ef032ddc3"
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
