class Idris2 < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris2/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "7a8612a1cd9f1f737893247260c6942bf93f193375d4b3df0148f7abf74d6e14"
  license "BSD-3-Clause"
  head "https://github.com/idris-lang/Idris2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c6e14db5e8506c6cb1d7a520bec70111ef2034fec55fc8575d421647d308689c"
    sha256 cellar: :any,                 arm64_ventura:  "a3d11aee7d2e8b4d29977d278b7b1a80d89b7e8b114119496343c53d6aed2883"
    sha256 cellar: :any,                 arm64_monterey: "fb7e8896bba8b9aa01b7b9073d1fa38727a08c5b86ac3cbeb7413f8f2e485794"
    sha256 cellar: :any,                 sonoma:         "5b8fd2e2aa345db5391e28434b3dc8ee9d9eae47c377976cd89ba6e76a24982b"
    sha256 cellar: :any,                 ventura:        "3efd6fe237182b34b8053e0395cbb9ac91ab1609b7771934aafb5466e0768f9c"
    sha256 cellar: :any,                 monterey:       "a08103ebeeb1018d77ea01cec7b053dd2f1bc7b2418aa5418fe9cca037b23ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "795f75e40930132daec2b20eec16ef0182a3cf0773486954012719614788481d"
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
