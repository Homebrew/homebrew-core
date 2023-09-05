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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e2f219174f367e4f191679e888c14db8391a531f99e5830a491ca7a5a38d5a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e2f219174f367e4f191679e888c14db8391a531f99e5830a491ca7a5a38d5a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e2f219174f367e4f191679e888c14db8391a531f99e5830a491ca7a5a38d5a9"
    sha256 cellar: :any_skip_relocation, ventura:        "ef0ff79ca1a2494626667efc995c8e3ff75993889d75312fd46d9acb408d0e4c"
    sha256 cellar: :any_skip_relocation, monterey:       "ef0ff79ca1a2494626667efc995c8e3ff75993889d75312fd46d9acb408d0e4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef0ff79ca1a2494626667efc995c8e3ff75993889d75312fd46d9acb408d0e4c"
    sha256 cellar: :any_skip_relocation, catalina:       "ef0ff79ca1a2494626667efc995c8e3ff75993889d75312fd46d9acb408d0e4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4791ddff487d774346c8e313b7b3bee367ca06cdc79bef543da253166401cbab"
  end

  depends_on "docbook"
  depends_on "python@3.11"
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
