class Asciidoc < Formula
  include Language::Python::Virtualenv

  desc "Formatter/translator for text files to numerous formats"
  homepage "https://asciidoc-py.github.io/"
  url "https://files.pythonhosted.org/packages/45/f0/05c069f44f22da7737cec85b067b79e6c2bd29db66e0f13ebb67e8ea51b3/asciidoc-10.1.2.tar.gz"
  sha256 "9a91329a57e518efab94c8d70be8dd058a5a9db226d2e60718ea58d46162a0d6"
  license "GPL-2.0-only"
  head "https://github.com/asciidoc-py/asciidoc-py.git", branch: "main"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a099ec1029d65cdcbb9f9d94a7f010c6aefb1ba3b7684307eebfb454265211b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a099ec1029d65cdcbb9f9d94a7f010c6aefb1ba3b7684307eebfb454265211b"
    sha256 cellar: :any_skip_relocation, monterey:       "343f9f2d6e59c4cdd618b6edaea7f28cd052dad3ab0a622c64fb78adabbe2a84"
    sha256 cellar: :any_skip_relocation, big_sur:        "343f9f2d6e59c4cdd618b6edaea7f28cd052dad3ab0a622c64fb78adabbe2a84"
    sha256 cellar: :any_skip_relocation, catalina:       "343f9f2d6e59c4cdd618b6edaea7f28cd052dad3ab0a622c64fb78adabbe2a84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5f8e378316f32a0b55cbc1a2c5f41f49c4d6cdf2c368fbf1b3cf24f8b044325"
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
