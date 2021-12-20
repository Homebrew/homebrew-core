class Asciidoc < Formula
  include Language::Python::Virtualenv

  desc "Formatter/translator for text files to numerous formats"
  homepage "https://asciidoc-py.github.io/"
  url "https://files.pythonhosted.org/packages/4b/c0/ded4666a6d7a978b50fda85f44ba7f0939bd92838102769eca91a769aa9f/asciidoc-10.1.1.tar.gz"
  sha256 "33ac648f7b38fa8712cfdbbfd2465a263fea2dcd106946fcf7d59ae6473b47c5"
  license "GPL-2.0-only"
  head "https://github.com/asciidoc-py/asciidoc-py.git", branch: "main"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ead2a24b8600a3574ea487fe320daae09bd941d760d5692fe73f1345a2b599af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ead2a24b8600a3574ea487fe320daae09bd941d760d5692fe73f1345a2b599af"
    sha256 cellar: :any_skip_relocation, monterey:       "7afdccd97ac18d6c0a96ca818aeb2f64ac3119dd6ed33dd78910adb246733cd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "7afdccd97ac18d6c0a96ca818aeb2f64ac3119dd6ed33dd78910adb246733cd9"
    sha256 cellar: :any_skip_relocation, catalina:       "7afdccd97ac18d6c0a96ca818aeb2f64ac3119dd6ed33dd78910adb246733cd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8a02bc9d56089d62e6080688fd903c701c0ef2224b5206c0743ee2329fca1be"
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
