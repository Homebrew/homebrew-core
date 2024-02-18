class Chezscheme < Formula
  desc "Implementation of the Chez Scheme language"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/releases/download/v10.0.0/csv10.0.0.tar.gz"
  sha256 "d37199012b5ed1985c4069d6a87ff18e5e1f5a2df27e402991faf45dc4f2232c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "041cfbb591db74e11611099248e00c428eb50fe5230140de1196de476389d89c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb57159e3717a654c41103593f45476aa45638442e54f350d6463bdd26ba500a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "708326531c59c33f0806ecd23fdb5fa1a0915da6523485d8299302424cc9cd07"
    sha256 cellar: :any_skip_relocation, sonoma:         "554001e15c93bb99e0d5caabf9143f72c073b480e2d1c6abba7a5b57d6a52fb1"
    sha256 cellar: :any_skip_relocation, ventura:        "2db40142397688c10ecb57bd74ae0249cd004668e6c50d09daa1f8acad54fe6a"
    sha256 cellar: :any_skip_relocation, monterey:       "b46dcb58270a1e656fb18d4ff344c1078cd337af0b05efde2ac96e48fbd636f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55203016d10b96b4b99d96cea642c9a987e71182651f4509ccb3e5b2ce74d4bf"
  end

  depends_on "libx11" => :build
  depends_on "xterm"
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
