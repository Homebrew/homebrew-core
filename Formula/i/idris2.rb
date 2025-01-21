class Idris2 < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris2/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "7a8612a1cd9f1f737893247260c6942bf93f193375d4b3df0148f7abf74d6e14"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/idris-lang/Idris2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "e2aff42043c3dd37846fa91f07bf5d402f8ca937f666b041a78f1ad21d22a355"
    sha256 cellar: :any, arm64_sonoma:  "aec7750a75d554db5be7a85e57b7e89f7b2dc04d3874e4c97d0619faada67ac7"
    sha256 cellar: :any, arm64_ventura: "1600ff494b3297aabd33f4601dd460cf370be259931e09e71a125163191d278b"
    sha256 cellar: :any, sonoma:        "78a12b89785b8d634fb112311a26c5a37a383fe09819416a0955326e54082a00"
    sha256 cellar: :any, ventura:       "e5f091bcbd8281136c7c7a0c8474efe76eb1f65e1c192ffb68efc7d5a186122e"
    sha256               x86_64_linux:  "1c641c4b960ae02d8ffada1508b1bd4b6cfaf9e8fa917ccddfb15e427dac9e73"
  end

  depends_on "gmp" => :build
  depends_on "chezscheme"

  on_high_sierra :or_older do
    depends_on "zsh" => :build
  end

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
