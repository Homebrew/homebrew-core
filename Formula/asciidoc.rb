class Asciidoc < Formula
  include Language::Python::Virtualenv

  desc "Formatter/translator for text files to numerous formats"
  homepage "https://asciidoc-py.github.io/"
  url "https://files.pythonhosted.org/packages/6e/29/9c981dfb1bf5b2b390b9f06589930930e07b05b333e4e2a531f2f122bee1/asciidoc-10.1.3.tar.gz"
  sha256 "9d2b09325fef303afa6e7675342eb99ef1f1a65e82c454183b9c7f4d129b0b1a"
  license "GPL-2.0-only"
  head "https://github.com/asciidoc-py/asciidoc-py.git", branch: "main"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb9ce48214412f4b99439508f417aaf62ef536a350fe33800bdddf0762f01513"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb9ce48214412f4b99439508f417aaf62ef536a350fe33800bdddf0762f01513"
    sha256 cellar: :any_skip_relocation, monterey:       "a5dc18f6e8764f506d8691737754fb27d06e1b2ad822d395741910d66b6ba24a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5dc18f6e8764f506d8691737754fb27d06e1b2ad822d395741910d66b6ba24a"
    sha256 cellar: :any_skip_relocation, catalina:       "a5dc18f6e8764f506d8691737754fb27d06e1b2ad822d395741910d66b6ba24a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b23a19f7761a23d9dd499c7f45b76dc9a5b87dfec50435012ca5c92dded811ae"
  end

  depends_on "docbook"
  depends_on "python@3.10"
  depends_on "source-highlight"

  def install
    virtualenv_install_with_resources
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
    system "#{bin}/asciidoc", "-b", "html5", "-o", testpath/"test.html", testpath/"test.txt"
    assert_match %r{<h2 id="_hello_world">Hello World!</h2>}, File.read(testpath/"test.html")
  end
end
