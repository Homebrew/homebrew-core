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
    rebuild 6
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "215cdd544ce3046f58f868347c476c8fa83b3391b2a700e6ddd1f9b65b0e9c4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "215cdd544ce3046f58f868347c476c8fa83b3391b2a700e6ddd1f9b65b0e9c4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "215cdd544ce3046f58f868347c476c8fa83b3391b2a700e6ddd1f9b65b0e9c4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "14ebbae301d847d3e1eb0a62f632982736583120d816f6cd4489fea56ccf8629"
    sha256 cellar: :any_skip_relocation, ventura:        "14ebbae301d847d3e1eb0a62f632982736583120d816f6cd4489fea56ccf8629"
    sha256 cellar: :any_skip_relocation, monterey:       "14ebbae301d847d3e1eb0a62f632982736583120d816f6cd4489fea56ccf8629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30bef817c3d4b470c4290451311aac33acc092dcaef0b42e8ba2c8444646abb8"
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
    system "#{bin}/asciidoc", "-b", "html5", "-o", testpath/"test.html", testpath/"test.txt"
    assert_match %r{<h2 id="_hello_world">Hello World!</h2>}, File.read(testpath/"test.html")
  end
end
