class Asciidoc < Formula
  include Language::Python::Virtualenv

  desc "Formatter/translator for text files to numerous formats"
  homepage "https://asciidoc-py.github.io/"
  url "https://files.pythonhosted.org/packages/1d/e7/315a82f2d256e9270977aa3c15e8fe281fd7c40b8e2a0b97e0cb61ca8fa0/asciidoc-10.2.1.tar.gz"
  sha256 "d9f13c285981b3c7eb660d02ca0a2779981e88d48105de81bb40445e60dddb83"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/asciidoc-py/asciidoc-py.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1bc7364d821058b91231a5ccf9481b508bd85713522c2d2702c51807feecef78"
  end

  depends_on "docbook"
  depends_on "python@3.14"
  depends_on "source-highlight"

  uses_from_macos "libxml2"

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
