class Asciidoc < Formula
  include Language::Python::Virtualenv

  desc "Formatter/translator for text files to numerous formats"
  homepage "https://asciidoc-py.github.io/"
  url "https://files.pythonhosted.org/packages/1d/e7/315a82f2d256e9270977aa3c15e8fe281fd7c40b8e2a0b97e0cb61ca8fa0/asciidoc-10.2.1.tar.gz"
  sha256 "d9f13c285981b3c7eb660d02ca0a2779981e88d48105de81bb40445e60dddb83"
  license "GPL-2.0-or-later"
  head "https://github.com/asciidoc-py/asciidoc-py.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec67acbcd8040ec963e8d3c2cab2427254d2b8b411b65db720347518ab341559"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec67acbcd8040ec963e8d3c2cab2427254d2b8b411b65db720347518ab341559"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec67acbcd8040ec963e8d3c2cab2427254d2b8b411b65db720347518ab341559"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec67acbcd8040ec963e8d3c2cab2427254d2b8b411b65db720347518ab341559"
    sha256 cellar: :any_skip_relocation, ventura:       "ec67acbcd8040ec963e8d3c2cab2427254d2b8b411b65db720347518ab341559"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a96f1dae62e892080b2da1d5d284af5978ba48edda0e76e04b30e309e8e4aaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51190b8ffe36e536f0208a5d0f420ed9be8c119051241188801d181a12bfd83a"
  end

  depends_on "docbook"
  depends_on "python@3.13"
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
