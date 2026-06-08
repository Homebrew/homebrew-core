class Chezscheme < Formula
  desc "Implementation of the Chez Scheme language"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/releases/download/v10.4.1/csv10.4.1.tar.gz"
  sha256 "2e74952db7bc177f0c3602e2217a341ba677d733eec4cd7726418c3a4e1ef308"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d4b81b7346fa611f3035f53f94320a1f63ab41af0077d30701c31acb9994a66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c74f9813bf5b89b6b75e771d77b33cd6a58dc91389ed92fd6852e27edc0eca08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97076a147bfcc04e3039736cbc0a452479367755165c48a8f5887fd537736177"
    sha256 cellar: :any_skip_relocation, sonoma:        "756b5dc8d1146dd5061a4a68b9cc5e4fcdbc286ca0cfc81e4bddcb41be79f0b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bead4424779d0804becf8c3eb84633ada805679bb79dc07defa5a72e7e2dcbe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9e42873dc1d618f3a5b8935b21ce1ea3f2a398e4a27fb2643a01d8a72a98afb"
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
