class Chezscheme < Formula
  desc "Implementation of the Chez Scheme language"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/archive/v9.5.8.tar.gz"
  sha256 "a00b1fb1c175dd51ab2efee298c3323f44fe901ab3ec6fbb6d7a3d9ef66bf989"
  license "Apache-2.0"

  bottle do
    sha256                               ventura:      "88a5884b10c70dc190bca0ebd209f9b47e361e0168366c12375953ec112b10eb"
    sha256                               monterey:     "543881937eaf579ac51632831a010c6a95c1e8cf0757d3e55b7dd882e0899a16"
    sha256                               big_sur:      "dd2412bb1590f7d03c8bbc9a668daefb1eb847c76862f1e57c3b8c44441f5e74"
    sha256                               catalina:     "93730ca19f3472845b787b7d7e14de4f805c92b08da845a30f55e668dd54338f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "baa942f1a73a26f74723ef398c88f8126fb481d7b313897d5cc07beff343c09c"
  end

  depends_on "libx11" => :build
  depends_on arch: :x86_64 # https://github.com/cisco/ChezScheme/issues/544
  depends_on "xterm"
  uses_from_macos "ncurses"

  def install
    inreplace "configure", "/opt/X11", Formula["libx11"].opt_prefix
    inreplace Dir["c/Mf-*osx"], "/opt/X11", Formula["libx11"].opt_prefix
    inreplace "c/version.h", "/usr/X11R6", Formula["libx11"].opt_prefix
    inreplace "c/expeditor.c", "/usr/X11/bin/resize", Formula["xterm"].opt_bin/"resize"

    system "./configure",
              "--installprefix=#{prefix}",
              "--threads",
              "--installschemename=chez"
    system "make", "install"
  end

  test do
    (testpath/"hello.ss").write <<~EOS
      (display "Hello, World!") (newline)
    EOS

    expected = <<~EOS
      Hello, World!
    EOS

    assert_equal expected, shell_output("#{bin}/chez --script hello.ss")
  end
end
