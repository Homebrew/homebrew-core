class Idris2 < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris2/archive/v0.6.0.tar.gz"
  sha256 "7f5597652ed26abc2d2a6ed4220ec28fafdab773cfae0062a8dfafe7d133e633"
  license "BSD-3-Clause"
  head "https://github.com/idris-lang/Idris2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 monterey:     "d905ded56aaa8c99d992c3e84e7e02d9d5f9c77089143abce7ddd4d8f8f1f4b2"
    sha256 cellar: :any,                 big_sur:      "6f4a6e589b386f30801c0cf36ee61cfc35017ded177bcae84235c2562058417c"
    sha256 cellar: :any,                 catalina:     "ff005be1e9e4fafc1a20f04f51aa4d72ecc918df190b2dac6b2b341bd3e455ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6ed08bd3734a40d1ecebc329afdddc7165d894dc043966fcc7e03ea354347194"
  end

  depends_on "gmp" => :build

  on_high_sierra :or_older do
    depends_on "zsh" => :build
  end

  # Use Racket fork of Chez Scheme for Apple Silicon support while main formula lacks support.
  # https://github.com/idris-lang/Idris2/blob/main/INSTALL.md#installing-chez-scheme-on-apple-silicon
  on_arm do
    depends_on "lz4"

    resource "chezscheme" do
      url "https://github.com/racket/ChezScheme.git",
          tag:      "racket-v8.6",
          revision: "9383dda64db9f430a95bb5cf014af2afdc71fb0c"
    end
  end

  on_intel do
    depends_on "chezscheme"
  end

  def install
    scheme = if Hardware::CPU.arm?
      resource("chezscheme").stage do
        rm_r %w[lz4 zlib]
        args = %w[LZ4=-llz4 ZLIB=-lz]

        system "./configure", "--pb", *args
        system "make", "auto.bootquick"
        system "./configure", "--disable-x11",
                              "--installprefix=#{libexec}/chezscheme",
                              "--installschemename=chez",
                              "--threads",
                              *args
        system "make"
        system "make", "install"
      end
      libexec/"chezscheme/bin/chez"
    else
      Formula["chezscheme"].opt_bin/"chez"
    end

    ENV.deparallelize
    ENV["CHEZ"] = scheme
    system "make", "bootstrap", "SCHEME=#{scheme}", "PREFIX=#{libexec}"
    system "make", "install", "PREFIX=#{libexec}"
    if Hardware::CPU.arm?
      (bin/"idris2").write_env_script libexec/"bin/idris2", CHEZ: "${CHEZ:-#{scheme}}"
    else
      bin.install_symlink libexec/"bin/idris2"
    end
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
