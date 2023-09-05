class Idris2 < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris2/archive/v0.6.0.tar.gz"
  sha256 "7f5597652ed26abc2d2a6ed4220ec28fafdab773cfae0062a8dfafe7d133e633"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/idris-lang/Idris2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1b0403d50b6f4051e8819ee620b1ea1d821220bbbd81757538f30b0650bbde02"
    sha256 cellar: :any,                 arm64_monterey: "fe954c126580a4dce5e362731af0450ee58a592567ed61c4577a6f4ebc4fdc80"
    sha256 cellar: :any,                 arm64_big_sur:  "87a4f6c28283471b0e6ffb0d5014c5f19407cf529ae06ac394d738a8c78a14a6"
    sha256 cellar: :any,                 ventura:        "6d3669405d16c316734407fca9ad6f9c08979469ab4e94978bb9590b675dc880"
    sha256 cellar: :any,                 monterey:       "f749917597db5e0325e46a193d756fda2b3b68cdf0d0c6217f7f6d0cb3fc7526"
    sha256 cellar: :any,                 big_sur:        "b4654aca4c0b6b8388e0eeb1816df35d073d50de97c9f32c04b6a1041ec184c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bec98e3d1ec010bc075382337f925b0517899d76e11590c6860aa8804ea25117"
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
          tag:      "racket-v8.9",
          revision: "baa880391bdb6b1e24cd9bb2020c6865a0fa065a"
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
