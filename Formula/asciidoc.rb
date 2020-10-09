class Asciidoc < Formula
  include Language::Python::Shebang

  desc "Formatter/translator for text files to numerous formats. Includes a2x"
  homepage "https://asciidoc.org/"
  url "https://github.com/asciidoc/asciidoc-py3/archive/9.0.3.tar.gz"
  sha256 "c0de1dcf111a200bf85bd81f67bc18778f839e55d761d6c7320095985524853a"
  license "GPL-2.0"
  revision 1
  head "https://github.com/asciidoc/asciidoc-py3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "35432712b96f6c242f69dce68cb0a1c694666dcbbb59ada1b52f44c5382c07c1" => :catalina
    sha256 "53a91455c88216dec9bf411065a8e8fa3d2b088e8a3c2859a3e10be1d84e1062" => :mojave
    sha256 "67864189bcd3e8d1f49107bd0cb6aaa5554c9227e5904e048343e8fb1483f29b" => :high_sierra
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
