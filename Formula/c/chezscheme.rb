class Chezscheme < Formula
  desc "Implementation of the Chez Scheme language"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/releases/download/v10.3.0/csv10.3.0.tar.gz"
  sha256 "d237d9874c6e8b0ccf7758daa8286a6e825528b13ce3b2bca56eb1f73cddbc2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fd70e9cfb444bc9a5ff5c872e7af6a625b8812455d08af0594550c890f5215d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b32cc85a153a2455e113b5542b0081abf642707131220539c02e4dba63a91d3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36a2d7bded5e28332d54e0657a1c291cd60e5aa80bedd51ba4749197dcaddd90"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2e2ccd0bb129de10fe9129a4b0f1eb1b2fb01a4159f9c62678c49346fe3ef93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b5ab9ca95255ace1bab78af45b899944ee8e3c9e3750965536541acc5c5ef9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c507bb094a948903427b7a955d0f1ff52a74907b1ffaecff6af5a31686811600"
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
