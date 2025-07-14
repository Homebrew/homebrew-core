class Chezscheme < Formula
  desc "Implementation of the Chez Scheme language"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/releases/download/v10.2.0/csv10.2.0.tar.gz"
  sha256 "b795916d4cfed59240c5f44b1b507a8657efd28e62e72e134d03486e9f3e374a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa0a0ef4b2e725411f40e15699d1cf6c98afd33553114c03290b5d448d386376"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "376de0a80c223e324d01d3fa9178e0109a51e9774eb0db7d24045e37646c2955"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1ebe98f204674543ece35ceb221fefe2c6ea54da1a93823efc3efaa2fa9c39a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccc44b15027ae267266b1621f54acfcba730a2ede1a69bc3432b2fcb85f4ee93"
    sha256 cellar: :any_skip_relocation, ventura:       "3eaf4e4baf01394ebf43b74f722253ec4775bc801c3d1872a9577d1518467e70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62a4f91d4e71185b6ba659800c09cb543e1d88a905e30638a8c2e72ea769a4f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ef79b89094ed46426bcfffa39786d547523ebbe711f68eec3d6b935c4e53240"
  end

  depends_on "libx11" => :build
  depends_on "xterm" => :build
  uses_from_macos "ncurses"

  def install
    inreplace "c/version.h", "/usr/X11R6", Formula["libx11"].opt_prefix
    inreplace "c/expeditor.c", "/usr/X11/bin/resize", Formula["xterm"].opt_bin/"resize"

    system "./configure",
              "--installprefix=#{prefix}",
              "--threads",
              "--installschemename=chez"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"hello.ss").write <<~SCHEME
      (display "Hello, World!") (newline)
    SCHEME

    expected = <<~EOS
      Hello, World!
    EOS

    assert_equal expected, shell_output("#{bin}/chez --script hello.ss")
  end
end
