class Asciidoc < Formula
  include Language::Python::Shebang

  desc "Formatter/translator for text files to numerous formats. Includes a2x"
  homepage "https://asciidoc.org/"
  url "https://github.com/asciidoc/asciidoc-py3/archive/9.0.1.tar.gz"
  sha256 "73af9ee590b050e9f46ef85eb7756944dffdc9b3333e3e60c153a6e1f1de0ba5"
  head "https://github.com/asciidoc/asciidoc-py3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0392e83663dd3c207c2880fc4e8868a32c64a47b9dd91a7a827705157faff76" => :catalina
    sha256 "a0392e83663dd3c207c2880fc4e8868a32c64a47b9dd91a7a827705157faff76" => :mojave
    sha256 "a0392e83663dd3c207c2880fc4e8868a32c64a47b9dd91a7a827705157faff76" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "docbook-xsl" => :build
  depends_on "docbook"
  depends_on "python@3.8"
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
