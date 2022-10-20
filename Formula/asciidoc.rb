class Asciidoc < Formula
  include Language::Python::Virtualenv

  desc "Formatter/translator for text files to numerous formats"
  homepage "https://asciidoc-py.github.io/"
  url "https://files.pythonhosted.org/packages/8a/57/50180e0430fdb552539da9b5f96f1da6f09c4bfa951b39a6e1b4fbe37d75/asciidoc-10.2.0.tar.gz"
  sha256 "91ff1dd4c85af7b235d03e0860f0c4e79dd1ff580fb610668a39b5c77b4ccace"
  license "GPL-2.0-only"
  head "https://github.com/asciidoc-py/asciidoc-py.git", branch: "main"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe3204e432010e16e1d4d6d3d79f132478eea0ef8c7404532bb8a639f7280cf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe3204e432010e16e1d4d6d3d79f132478eea0ef8c7404532bb8a639f7280cf6"
    sha256 cellar: :any_skip_relocation, monterey:       "b132c3cc85f2fa12e693fc93fe640c0a3676a85747687a5917a11af7821c8667"
    sha256 cellar: :any_skip_relocation, big_sur:        "b132c3cc85f2fa12e693fc93fe640c0a3676a85747687a5917a11af7821c8667"
    sha256 cellar: :any_skip_relocation, catalina:       "b132c3cc85f2fa12e693fc93fe640c0a3676a85747687a5917a11af7821c8667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4d01353c3c3b4861f06cecea12eb77bfe261e32e19a784c6df6e209170b1293"
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
