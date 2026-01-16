class Jsbeautifier < Formula
  include Language::Python::Virtualenv

  desc "JavaScript unobfuscator and beautifier"
  homepage "https://beautifier.io"
  url "https://files.pythonhosted.org/packages/ea/98/d6cadf4d5a1c03b2136837a435682418c29fdeb66be137128544cecc5b7a/jsbeautifier-1.15.4.tar.gz"
  sha256 "5bb18d9efb9331d825735fbc5360ee8f1aac5e52780042803943aa7f854f7592"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "61e5e7670ad6ea25f829c70fbc441d2bb4602c993ea36cdf1dcc829b344e57df"
  end

  depends_on "python@3.14"

  conflicts_with "js-beautify", because: "both install `js-beautify` binaries"

  resource "editorconfig" do
    url "https://files.pythonhosted.org/packages/88/3a/a61d9a1f319a186b05d14df17daea42fcddea63c213bcd61a929fb3a6796/editorconfig-0.17.1.tar.gz"
    sha256 "23c08b00e8e08cc3adcddb825251c497478df1dada6aefeb01e626ad37303745"
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
