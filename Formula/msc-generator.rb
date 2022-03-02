class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://sourceforge.net/p/msc-generator"
  url "https://downloads.sourceforge.net/project/msc-generator/msc-generator/v7.x/msc-generator-7.2.tar.gz"
  sha256 "40c7a45e1bce96bc93440b604eb0fd2b7894985fa0a723bf6483565bef026a2e"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "0a7c679b4ada83af473a093c60db6a80ee7a15179e09d27eabc76245cd24ba27"
    sha256 cellar: :any, arm64_big_sur:  "93a94d78c635a6eb3cb5f001b0edde020cff8161a9dbc7a0b1e49abcc355e0cf"
    sha256 cellar: :any, monterey:       "d2a801331d157692f0e9e8799aa23508f1212a9c5bd72b2fbb2d1e0131c9d763"
    sha256 cellar: :any, big_sur:        "45731f37d92771b0065740a1bafe2cead12863e10be89d921961bcbd9db0a1a6"
    sha256 cellar: :any, catalina:       "98eb2f5b8a2c8f247dced6ee8c23a794575cd2d389a4cb4c254241ad4e8c052c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gcc"
  depends_on "glpk"
  depends_on "graphviz"
  depends_on "sdl2"

  fails_with :clang # needs std::range

  fails_with :gcc do
    version "9"
    cause "needs std::range"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-font-checks"
    # Dance around upstream trying to build everything in doc/ which we don't do for now
    # system "make", "install"
    system "make", "-C", "src", "install"
    system "make", "-C", "doc", "msc-gen.1"
    man1.install "doc/msc-gen.1"
  end

  test do
    # Try running the program
    system "#{bin}/msc-gen", "--version"
    # Construct a simple chart and check if PNG is generated (the default output format)
    (testpath/"simple.signalling").write("a->b;")
    system "#{bin}/msc-gen", "simple.signalling"
    assert_predicate testpath/"simple.png", :exist?
    bytes = File.binread(testpath/"simple.png")
    assert_equal bytes[0..7], "\x89PNG\r\n\x1a\n".force_encoding("ASCII-8BIT")
  end
end
