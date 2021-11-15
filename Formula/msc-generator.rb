class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://sourceforge.net/p/msc-generator"
  url "https://downloads.sourceforge.net/project/msc-generator/msc-generator/v7.x/msc-generator-7.0.4.tar.gz"
  sha256 "d79db7c6fb262564374301281cc589682c974b6b7872b37329500f6f79767480"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4002f6c6b3339dd353f0af7a396a1b86e89f480c2cbcd8b643e1c0bb5926d0b1"
    sha256 cellar: :any, big_sur:       "90dcd8501b61dde64a68603e2e707b27541acdcc6f6a293bfad99abb99f179d7"
    sha256 cellar: :any, catalina:      "bf2fe8c703116ca931ae8f85916fc056225b4253a19b985d04237ddb76e1e776"
    sha256 cellar: :any, mojave:        "518e35b8b95c33b78c72fcfe3a4a4d75586963719f2a7c21437cb7cd311dbdbd"
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

  def install
    system "./configure", "--prefix=#{prefix}"
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
    bytes = File.open(testpath/"simple.png", "rb").read
    assert_equal bytes[0..7], "\x89PNG\r\n\x1a\n".force_encoding("ASCII-8BIT")
  end
end
