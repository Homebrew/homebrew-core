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
    sha256 "a7f6a49939e627eece6cddf4cbb91ae72922e6beb88ae9715cfd479051b3fb4b" => :big_sur
    sha256 "a27b62e2f37f96b534abb47af010a7b6282339439a4a3b19682544e7634f3ca1" => :arm64_big_sur
    sha256 "0d4c6143d618720d9d1907d4a914b0ba685e67ee024859de3afb7fb6f50bbbb5" => :catalina
    sha256 "23836dcab06fc863b9babf4501179317d6e28899a83f078aca1cac564ef585e2" => :mojave
    sha256 "e61daf8474cb187643e49c313b839c957dbaecc5944ed43c9b8a8116ff656a5f" => :high_sierra
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
