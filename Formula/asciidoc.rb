class Asciidoc < Formula
  include Language::Python::Virtualenv

  desc "Formatter/translator for text files to numerous formats"
  homepage "https://asciidoc-py.github.io/"
  url "https://files.pythonhosted.org/packages/c3/b6/f874a6e5ecfb7192a0199dd7652a7a8401a52090e3f6bf4a07b7b76a92ae/asciidoc-10.1.0.tar.gz"
  sha256 "276e289ff780897b3e87f4e6420c8370d5712c442ce68eebad319bf41f2c839c"
  license "GPL-2.0-only"
  head "https://github.com/asciidoc-py/asciidoc-py.git", branch: "main"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59bc4ac9a515e3b9fb04413170253db01735afda37468487bc7c4e05c56cda7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59bc4ac9a515e3b9fb04413170253db01735afda37468487bc7c4e05c56cda7d"
    sha256 cellar: :any_skip_relocation, monterey:       "03ab2d49198b047f011cdacdfbb9f08260d4ecab0657b3b74dc99034db6085c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "03ab2d49198b047f011cdacdfbb9f08260d4ecab0657b3b74dc99034db6085c7"
    sha256 cellar: :any_skip_relocation, catalina:       "03ab2d49198b047f011cdacdfbb9f08260d4ecab0657b3b74dc99034db6085c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d64213d02fb9f66ef08fb25987477d3d1c0b3e876ba8a74ae2153610a269f1e3"
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
