class Asciidoc < Formula
  desc "Formatter/translator for text files to numerous formats. Includes a2x"
  homepage "http://asciidoc.org/"
  # This release is listed as final on GitHub, but not listed on asciidoc.org.
  url "https://github.com/asciidoc/asciidoc/archive/8.6.10.tar.gz"
  sha256 "9e52f8578d891beaef25730a92a6e723596ddbd07bfe0d2a56486fcf63a0b983"
  revision 2
  head "https://github.com/asciidoc/asciidoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f89040aa055faab054a4b82e0cdfec724b57529844368c2f4fe81683ee2967f9" => :mojave
    sha256 "0a021fbfe992e2357c6d6b9b940ca3b080911a6d156bd3fb52775c452a272075" => :high_sierra
    sha256 "0a021fbfe992e2357c6d6b9b940ca3b080911a6d156bd3fb52775c452a272075" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "docbook-xsl" => :build
  depends_on "docbook"
  depends_on "source-highlight"

  def install
    ENV.prepend_path "PATH", "/System/Library/Frameworks/Python.framework/Versions/2.7/bin"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "autoconf"
    system "./configure", "--prefix=#{prefix}"

    inreplace %w[a2x.py asciidoc.py filters/code/code-filter.py
                 filters/graphviz/graphviz2png.py filters/latex/latex2img.py
                 filters/music/music2png.py filters/unwraplatex.py],
      "#!/usr/bin/env python2", "#!/usr/bin/python"

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
    assert_match %r{\<h2 id="_hello_world"\>Hello World!\</h2\>}, File.read("test.html")
  end
end
