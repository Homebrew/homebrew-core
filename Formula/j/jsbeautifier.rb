class Jsbeautifier < Formula
  include Language::Python::Virtualenv

  desc "JavaScript unobfuscator and beautifier"
  homepage "https://beautifier.io"
  url "https://files.pythonhosted.org/packages/ea/98/d6cadf4d5a1c03b2136837a435682418c29fdeb66be137128544cecc5b7a/jsbeautifier-1.15.4.tar.gz"
  sha256 "5bb18d9efb9331d825735fbc5360ee8f1aac5e52780042803943aa7f854f7592"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cfa936f6a98eda6de5121e7cd9ccf0513039230f59e0d2cabc159526f98e19ec"
  end

  depends_on "python@3.13"

  conflicts_with "js-beautify", because: "both install `js-beautify` binaries"

  resource "editorconfig" do
    url "https://files.pythonhosted.org/packages/b4/29/785595a0d8b30ab8d2486559cfba1d46487b8dcbd99f74960b6b4cca92a4/editorconfig-0.17.0.tar.gz"
    sha256 "8739052279699840065d3a9f5c125d7d5a98daeefe53b0e5274261d77cb49aa2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    javascript = "if ('this_is'==/an_example/){of_beautifier();}else{var a=b?(c%d):e[f];}"
    assert_equal <<~EOS.chomp, pipe_output(bin/"js-beautify", javascript)
      if ('this_is' == /an_example/) {
          of_beautifier();
      } else {
          var a = b ? (c % d) : e[f];
      }
    EOS
  end
end
