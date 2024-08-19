class Asciidoc < Formula
  include Language::Python::Virtualenv

  desc "Formatter/translator for text files to numerous formats"
  homepage "https://asciidoc-py.github.io/"
  url "https://files.pythonhosted.org/packages/1d/e7/315a82f2d256e9270977aa3c15e8fe281fd7c40b8e2a0b97e0cb61ca8fa0/asciidoc-10.2.1.tar.gz"
  sha256 "d9f13c285981b3c7eb660d02ca0a2779981e88d48105de81bb40445e60dddb83"
  license "GPL-2.0-or-later"
  head "https://github.com/asciidoc-py/asciidoc-py.git", branch: "main"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7289219aacccff18740c6234ac438cc39c8f1ebd2a31a5e5ddc5a62f222ca200"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7289219aacccff18740c6234ac438cc39c8f1ebd2a31a5e5ddc5a62f222ca200"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7289219aacccff18740c6234ac438cc39c8f1ebd2a31a5e5ddc5a62f222ca200"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ab32cd1cb6941a93ad04eede903bccef924de598f18ce3e3ceae24f352df018"
    sha256 cellar: :any_skip_relocation, ventura:        "7ab32cd1cb6941a93ad04eede903bccef924de598f18ce3e3ceae24f352df018"
    sha256 cellar: :any_skip_relocation, monterey:       "0d6d5e9be887a617249f785eb76402192778a5fc2885f17a9e8a9cc7595b9c29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f7189d7ff2776ad9f27dcb9403f90f435f48e615552eb16db2972fc43616e38"
  end

  depends_on "docbook"
  depends_on "python@3.12"
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
    system bin/"asciidoc", "-b", "html5", "-o", testpath/"test.html", testpath/"test.txt"
    assert_match %r{<h2 id="_hello_world">Hello World!</h2>}, File.read(testpath/"test.html")
  end
end
