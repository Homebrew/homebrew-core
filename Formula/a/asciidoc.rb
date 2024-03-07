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
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3834a488c93f7a1522c4a596fa383a5cadb27f6045b0a26c17eb8a8c99d30e10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7afba011d483337a5ff13df2200bc0a45335fa2f39c48159327303ddedc58369"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69b57b7b584ae2b0d15b56335fcba892b02ea09f21047a0b668bd3eb8b61f08a"
    sha256 cellar: :any_skip_relocation, sonoma:         "fea52854fab730915cb84db51ac13ba795c589be3a7f164e6309f805da31be3f"
    sha256 cellar: :any_skip_relocation, ventura:        "3224221825401207a66e8f3f6b7989139470a60f852260765c2de1baa01abf61"
    sha256 cellar: :any_skip_relocation, monterey:       "b195c3d7304043083e0175de8ac7b564c27dd036df0818856bafcd9a61924ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d083b8c49e3299afc98a9678479fe47bdca90bef6fedbc517bb212b4668c104a"
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
