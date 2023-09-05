class Chezscheme < Formula
  desc "Implementation of the Chez Scheme language"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/releases/download/v9.6.2/csv9.6.2.tar.gz"
  sha256 "714695789e1bad3518e6cd5fbc8ae8204f76103d5ad2ba05a3f1c063eb2d5d02"
  license "Apache-2.0"

  bottle do
    sha256                               ventura:      "de3207d1764457f734baf69cef36ff9a4d3512010a676050f814f5084297ab9a"
    sha256                               monterey:     "78c14c05babdad4d67dc783d3f9642c2b7216ec6810825b00095b3086d507c2f"
    sha256                               big_sur:      "54934c125ba9a227ad14f7900627e6358df60d603073a8f38da780a4b212fad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d5628b64b2c41f53dd15835b09342a1dcbdd6871f2e3d13451bcc3a9935cee4f"
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
