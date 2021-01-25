class Asciidoc < Formula
  include Language::Python::Shebang

  desc "Formatter/translator for text files to numerous formats. Includes a2x"
  homepage "https://asciidoc.org/"
  url "https://github.com/asciidoc/asciidoc-py3/archive/9.0.5.tar.gz"
  sha256 "b73248717403fe49ef239b2bdb95f2b603e0af15ddd8f5e420f27707010bf95f"
  license "GPL-2.0-only"
  head "https://github.com/asciidoc/asciidoc-py3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdfe12fdf2042b563bc1a483ffa374af8a66e4cf0ba3016a391dc2fc21900543" => :big_sur
    sha256 "b1bcbcde0a7c320b6545b860c6970ba4fe3197fd9895bcd7213bc4e1d94e3fc8" => :arm64_big_sur
    sha256 "ea51b42dc1abaebdd7651c7f173425120abebe59d3fa71d44c6def60a737cdbe" => :catalina
    sha256 "fbd4303b8c1cfd427120a8b90e8504fd1d553b65243b8079e4d9e694f0a340d6" => :mojave
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
