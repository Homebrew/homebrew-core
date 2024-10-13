class Chezscheme < Formula
  desc "Implementation of the Chez Scheme language"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/releases/download/v10.0.0/csv10.0.0.tar.gz"
  sha256 "d37199012b5ed1985c4069d6a87ff18e5e1f5a2df27e402991faf45dc4f2232c"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "383ef05d3d088270e9621611a269d5865c3486e3b64972f944d73bf4ae9c8908"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee1fd372ef45e033935538cfad0a6362790260ef7b5d2784b491756c16adccca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "333374134b8b06bed7b86532b46a10ad15756254a6dcd345b3206b9535291b3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12d715a0ca6280e1f526deaf4a0e8f74282280be3062763e64aa5bdbc360fc57"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad447774b81335d4b26e15fd4a9b1934cdfcf96b3d54359517396f98acf7a0db"
    sha256 cellar: :any_skip_relocation, ventura:        "174810d0a11dc60f4137d336b71e2a633efd0fc36fb5271b3976b742568b4c97"
    sha256 cellar: :any_skip_relocation, monterey:       "677d9122cb99611dea8e88fc116513d18e361e05433e8ed7171e87df37c873a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f33bc7596361090dcbc3cd7eec1e226e9f8934b2da43684efef7763fbba2125"
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
    (testpath/"hello.ss").write <<~EOS
      (display "Hello, World!") (newline)
    EOS

    expected = <<~EOS
      Hello, World!
    EOS

    assert_equal expected, shell_output("#{bin}/chez --script hello.ss")
  end
end
