class Jsbeautifier < Formula
  include Language::Python::Virtualenv

  desc "JavaScript unobfuscator and beautifier"
  homepage "https://beautifier.io"
  url "https://files.pythonhosted.org/packages/69/3e/dd37e1a7223247e3ef94714abf572415b89c4e121c4af48e9e4c392e2ca0/jsbeautifier-1.15.1.tar.gz"
  sha256 "ebd733b560704c602d744eafc839db60a1ee9326e30a2a80c4adb8718adc1b24"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "01d73fd9b1ff227bfc84ebc058cd30c660ace2fb8ad98d485a3118b0778290f7"
  end

  depends_on "python@3.13"

  conflicts_with "js-beautify", because: "both install `js-beautify` binaries"

  resource "editorconfig" do
    url "https://files.pythonhosted.org/packages/3d/85/7b5c2fac7fdc37d959fab714b13b9acb75884490dcc0e8b1dc5e64105084/EditorConfig-0.12.4.tar.gz"
    sha256 "24857fa1793917dd9ccf0c7810a07e05404ce9b823521c7dce22a4fb5d125f80"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
