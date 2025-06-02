class Idris2 < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris2/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "7a8612a1cd9f1f737893247260c6942bf93f193375d4b3df0148f7abf74d6e14"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/idris-lang/Idris2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "f2e9a79eac9603493e64a21505f127cc98d64e418b5fbfd82ed02a9144b7dcb5"
    sha256 cellar: :any, arm64_sonoma:  "5b85059f83fe007bbf8de891999e16da762694cdec97ba66ad304f65c9a6e149"
    sha256 cellar: :any, arm64_ventura: "0a53ba9dcbb69069d2dcfa18c41a92507f950b7cba74e805f10be724e10cafcd"
    sha256 cellar: :any, sonoma:        "dbc307d2c2f47d019a8cc3a172434e05187bc1bc62f342d0c8b598b72a07e5ee"
    sha256 cellar: :any, ventura:       "f6eec5a8db64201ed600264c4ab6348fcbe70c9901d8c7f2337ad18530c3450e"
    sha256               arm64_linux:   "a0b776d5066bf8834d1ce1afc5b84ec6c514b7ad7c5cbe253875f320a514d6de"
    sha256               x86_64_linux:  "1bd3781f33f5138c4e88482b003c084ac56294258bc0115ee999d54a01290c99"
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
