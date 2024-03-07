class Asciidoc < Formula
  include Language::Python::Virtualenv

  desc "Formatter/translator for text files to numerous formats"
  homepage "https://asciidoc-py.github.io/"
  url "https://files.pythonhosted.org/packages/8a/57/50180e0430fdb552539da9b5f96f1da6f09c4bfa951b39a6e1b4fbe37d75/asciidoc-10.2.0.tar.gz"
  sha256 "91ff1dd4c85af7b235d03e0860f0c4e79dd1ff580fb610668a39b5c77b4ccace"
  license "GPL-2.0-or-later"
  head "https://github.com/asciidoc-py/asciidoc-py.git", branch: "main"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25a0f067e92ea485b45358fa8383dde366bbf7765cc983d786361350cbe7e260"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcdd7485192c3b9141c5195191ca3f721377c44193d1fb08c544763008e698db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1d0f7cb76f2a55f0f40fd71b58e2a5295d1b2c5a12234a17bdba9b49cddba82"
    sha256 cellar: :any_skip_relocation, sonoma:         "3eac82d44b524c1fff6a9ff5958b9c894b25e8fb3f39c23c0dedeeb2fdd0b2b0"
    sha256 cellar: :any_skip_relocation, ventura:        "a75130cdfcf32efb5d4d9923c20b4a3fafa7a412e7457cd8469ed61201b4d4d2"
    sha256 cellar: :any_skip_relocation, monterey:       "0a6c4db571f751947dcf6df3afc90e51a9def895032114e24556abff3b9b6669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35c1e427635ad87fda96566ec611a6149558de3398e460687484b6e801b39f68"
  end

  depends_on "docbook"
  depends_on "python@3.12"
  depends_on "source-highlight"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

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
