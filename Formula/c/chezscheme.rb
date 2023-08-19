class Chezscheme < Formula
  desc "Implementation of the Chez Scheme language"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/releases/download/v9.5.8a/csv9.5.8a.tar.gz"
  version "9.5.8a"
  sha256 "3e80ea08ae6fd336ffdda3fbbfa1ebcdda644670fa5bf6a5aa9100c82f381d52"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256                               ventura:      "03e2531cac39490b88689ab4b887b8bfa68fbbe36b82b021ae3fc9f2ff07781b"
    sha256                               monterey:     "1730b158fadf948716473ffe46fef88c2f1790edc5b75e3acfeb35d4549a6c2d"
    sha256                               big_sur:      "c3a055f85922bd002eb6725a89c3e077bea3222111ca0140d875e72742e6a84b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6bc534bc7a88a469fd6ab1a5680f79876b94c5ef1d568d0bdc9ed720bbcb1fec"
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
