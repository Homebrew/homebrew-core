class Chezscheme < Formula
  desc "Implementation of the Chez Scheme language"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/releases/download/v9.6.4/csv9.6.4.tar.gz"
  sha256 "f5827682fa259c47975ffe078785fb561e4a5c54f764331ef66c32132843685d"
  license "Apache-2.0"

  bottle do
    sha256                               sonoma:       "7bde84d1ef5d0878b0e544c02fd09d8721c8838940e039d140c99a3d7c2603c7"
    sha256                               ventura:      "31392d3de2181da6ced8af77927f35d72a47ea68720ee1325f0019fb48e4d449"
    sha256                               monterey:     "96ff356056109f07be45832cdca2c696c60a124ad9ef6d61ce94a5e6b36b26ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9ed36679ce44c6093e5aa47bf9f1ffdcd5943e88ced7f27c572cecd56a9a9fb4"
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
