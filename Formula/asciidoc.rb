class Asciidoc < Formula
  include Language::Python::Shebang

  desc "Formatter/translator for text files to numerous formats. Includes a2x"
  homepage "https://asciidoc.org/"
  url "https://github.com/asciidoc-py/asciidoc-py/archive/9.1.0.tar.gz"
  sha256 "5056c20157349f8dc74f005b6e88ccbf1078c4e26068876f13ca3d1d7d045fe7"
  license "GPL-2.0-only"
  head "https://github.com/asciidoc-py/asciidoc-py.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6687327cf31fe69822eb54e8fb1d411bc22237e346020beb69487bc55822583b"
    sha256 cellar: :any_skip_relocation, big_sur:       "3cae7527216fda7e1e3f46ef2ba9db4bf713c524ee70399afd322200d4bbcd32"
    sha256 cellar: :any_skip_relocation, catalina:      "84d2a53471facc216cf0b1022e8e57c7b0d7a07be8bbb8af727d55dcbdba2991"
    sha256 cellar: :any_skip_relocation, mojave:        "f1af645cce45046ab1e15b53676efc14d306e088547db2ee64e2678efdeecc5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc2c9c2b55f399e8f87b0603dabcedceb2711320563c3aa0b0fb368dc023f2e4"
  end

  depends_on "autoconf" => :build
  depends_on "docbook-xsl" => :build
  depends_on "docbook"
  depends_on "python@3.9"
  depends_on "source-highlight"

  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build

  on_linux do
    depends_on "xmlto" => :build
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "autoconf"
    system "./configure", "--prefix=#{prefix}"

    %w[
      a2x.py asciidoc.py filters/code/code-filter.py
      filters/graphviz/graphviz2png.py filters/latex/latex2img.py
      filters/music/music2png.py filters/unwraplatex.py
    ].map { |f| rewrite_shebang detected_python_shebang, f }

    # otherwise macOS's xmllint bails out
    inreplace "Makefile", "-f manpage", "-f manpage -L"
    system "make", "install"
    system "make", "docs"
  end

  def caveats
    <<~EOS
      If you intend to process AsciiDoc files through an XML stage
      (such as a2x for manpage generation) you need to add something
      like:

        export XML_CATALOG_FILES=#{etc}/xml/catalog

      to your shell rc file so that xmllint can find AsciiDoc's
      catalog files.

      See `man 1 xmllint' for more.
    EOS
  end

  test do
    (testpath/"test.txt").write("== Hello World!")
    system "#{bin}/asciidoc", "-b", "html5", "-o", "test.html", "test.txt"
    assert_match %r{<h2 id="_hello_world">Hello World!</h2>}, File.read("test.html")
  end
end
