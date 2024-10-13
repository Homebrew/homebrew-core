class Idris2 < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris2/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "7a8612a1cd9f1f737893247260c6942bf93f193375d4b3df0148f7abf74d6e14"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/idris-lang/Idris2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "52c0c93d3e2294b068a9a7083863ef581cc4cb15efa03fd2995c86970ecb5d43"
    sha256 cellar: :any, arm64_sonoma:   "2f0bb7a0ac274251c2c98120a847cb7d94276c977a6357b622ae65a93f060a4f"
    sha256 cellar: :any, arm64_ventura:  "06670ee2787183acaaf240b3a12516dfc83e746211926c74f450a13291084adc"
    sha256 cellar: :any, arm64_monterey: "ef585c08dc6636adb6d02214ae56efd2efd4c24d3b300f7e699882369fa8faed"
    sha256 cellar: :any, sonoma:         "ba3556bfec4e835e42d1949fbf9fe0020038611bc8afa680b1fb5b86357ae2cb"
    sha256 cellar: :any, ventura:        "f6a90b1d857776b6b0e0262819e130a8fad2104bef281fa90cd40bc161da6f65"
    sha256 cellar: :any, monterey:       "be2832c8d6ec99f5c763da2f464a1d179359702777008ac2d722500e958161d4"
    sha256               x86_64_linux:   "40a1b9a5a8326c4c23697fda7da0adaf26f1a872fb834d1e98299aea191d9608"
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
