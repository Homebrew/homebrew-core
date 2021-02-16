class Asciidoc < Formula
  include Language::Python::Shebang

  desc "Formatter/translator for text files to numerous formats. Includes a2x"
  homepage "https://asciidoc.org/"
  url "https://github.com/asciidoc-py/asciidoc-py/archive/9.1.0.tar.gz"
  sha256 "5056c20157349f8dc74f005b6e88ccbf1078c4e26068876f13ca3d1d7d045fe7"
  license "GPL-2.0-only"
  head "https://github.com/asciidoc-py/asciidoc-py.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0613eea2af2be4241ba6ccdeb94eb8c061bf07c5fd18ecc8e3a8d2ce0b3e1128"
    sha256 cellar: :any_skip_relocation, big_sur:       "4a13fb6be824ba6a60ccd646aa8d64535c41fb2a2bdf6cf242b5bd4e94a8d75b"
    sha256 cellar: :any_skip_relocation, catalina:      "e7dd75c43dd2370426f3383ee7975f5acbb2b9d4499ebd8404aa63d215b7d4f9"
    sha256 cellar: :any_skip_relocation, mojave:        "64d87ef7c0ba34bee18612d2fdfd623ad045cf9580cc88c9073a63a067d3e76f"
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
