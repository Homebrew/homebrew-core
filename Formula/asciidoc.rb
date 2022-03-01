class Asciidoc < Formula
  include Language::Python::Virtualenv

  desc "Formatter/translator for text files to numerous formats"
  homepage "https://asciidoc-py.github.io/"
  url "https://files.pythonhosted.org/packages/8f/94/aa5be7907b9dd1733e4e7a1fa0bb737022d6fb13f80a9283520c66435f4d/asciidoc-10.1.4.tar.gz"
  sha256 "e614fe7cd6ff096d2aea06733ecfb6b15411b2a0f4aef8267964a32c7f7472ac"
  license "GPL-2.0-only"
  head "https://github.com/asciidoc-py/asciidoc-py.git", branch: "main"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c481476e831d0af1a2cb5f7bd6fc0d1be7528e7e434684db292ec5393159cdc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c481476e831d0af1a2cb5f7bd6fc0d1be7528e7e434684db292ec5393159cdc7"
    sha256 cellar: :any_skip_relocation, monterey:       "3c0862fcbfa7be68166ca49e5308a0bd90ea7571d1b730bdac4e3268631b6076"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c0862fcbfa7be68166ca49e5308a0bd90ea7571d1b730bdac4e3268631b6076"
    sha256 cellar: :any_skip_relocation, catalina:       "3c0862fcbfa7be68166ca49e5308a0bd90ea7571d1b730bdac4e3268631b6076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5356dad49d65b08d80f6c643bcb4a89bbca0f79908b791de035f93b6a0b8732b"
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
