class Chezscheme < Formula
  desc "Implementation of the Chez Scheme language"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/archive/v9.5.6.tar.gz"
  sha256 "e23c556493f9a661852ea046f3317500feac5f223ea6ef3aa3b9234567e14c0e"
  license "Apache-2.0"

  bottle do
    sha256                               monterey:     "1d9118dd4d5ed319d4b6b3d3a2f7983154939045cf2a5e8f12a74c7ead260e8c"
    sha256                               big_sur:      "725156b49a096e44db6382cc483faff4ad8e7ec6fec83ca1998b94507d797f86"
    sha256                               catalina:     "a73f8d8d3049391bcd29d950c2dd4a9d816932855eefb0faa4bf7949c8f3837b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e6aefd17b0a0ac5f78abc7e746f6b7adc613c3040889d8bee47c16d9ca8c1b1d"
  end

  depends_on "libx11" => :build
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
