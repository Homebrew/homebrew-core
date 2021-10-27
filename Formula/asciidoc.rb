class Asciidoc < Formula
  include Language::Python::Virtualenv

  desc "Formatter/translator for text files to numerous formats"
  homepage "https://asciidoc-py.github.io/"
  url "https://files.pythonhosted.org/packages/6b/26/d2828867b366b73fc55b5ed51d7ad369195cc51d6293875ac152aa4b1742/asciidoc-10.0.0.tar.gz"
  sha256 "709e46e5fe528f9cf52272ec782a571e59c2f3776f6f67d49dd727351f669fdd"
  license "GPL-2.0-only"
  head "https://github.com/asciidoc-py/asciidoc-py.git", branch: "main"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a2d42fa8688dde1c94c9650ed46fdefc2b7877bc7ccd55271022d7f89820aa3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a2d42fa8688dde1c94c9650ed46fdefc2b7877bc7ccd55271022d7f89820aa3"
    sha256 cellar: :any_skip_relocation, monterey:       "e888d83cc14f9a6cda0c71bed44ed1578b116b9b8c3f76f6948c73acb9d1ea7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e888d83cc14f9a6cda0c71bed44ed1578b116b9b8c3f76f6948c73acb9d1ea7d"
    sha256 cellar: :any_skip_relocation, catalina:       "e888d83cc14f9a6cda0c71bed44ed1578b116b9b8c3f76f6948c73acb9d1ea7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a265c232637f028fd9bca2f2e993bce80261a2454b57169b10727cc100cb9363"
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
