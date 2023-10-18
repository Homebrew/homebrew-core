class Idris2 < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris2/archive/v0.6.0.tar.gz"
  sha256 "7f5597652ed26abc2d2a6ed4220ec28fafdab773cfae0062a8dfafe7d133e633"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/idris-lang/Idris2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "096ddbfbfccdbee8242d04157372aff355c2b36635700af0ef8e1e69ea69f946"
    sha256 cellar: :any,                 arm64_ventura:  "02908db1c3731c1319cd0c0236d99c903963b9e9332d8557f6ba2acbe826378c"
    sha256 cellar: :any,                 arm64_monterey: "31c73af3381e2a3574c69f45108a242bb9d778b01800684fc69b51284d2fa11f"
    sha256 cellar: :any,                 sonoma:         "9dc963bc486b967c3bbbd1b9209f7f08595b97dc957a6d70899cb4dc303e5495"
    sha256 cellar: :any,                 ventura:        "30e55e2cb668abbef2c4a56db77b6c70002e9d68888a4961dcae23761379c12b"
    sha256 cellar: :any,                 monterey:       "a18ad57d7c9c279744f20a833f4f0af478d39628bdfd466357314976799dfb38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb5499e2beb0f08d067d587744647f4b85f443a07268b8dab1aaaa67c87755b1"
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
