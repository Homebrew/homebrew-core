class Ddqa < Formula
  include Language::Python::Virtualenv

  desc "For Jira users to perform QA of future code releases"
  homepage "https://datadoghq.dev/ddqa/"
  url "https://files.pythonhosted.org/packages/5e/2e/6ab636010bf08ec9bf1fcfc7d5d5b67eee7dd719ef1f1634d8fc8fdbcdd6/ddqa-0.3.1.tar.gz"
  sha256 "9a467bc9c0055c0f70bd9e0158498ddc065250d3a62c29312c8b927c976f47d6"
  license "MIT"

  depends_on "pillow"
  depends_on "pygments"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/f8/2a/114d454cb77657dbf6a293e69390b96318930ace9cd96b51b99682493276/httpx-0.24.1.tar.gz"
    sha256 "5853a43053df830c20f8110c5e69fe44d035d850b2dfe795e196f00fdb774bdd"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d2/5d/29eed8861e07378ef46e956650615a9677f8f48df7911674f923236ced2b/platformdirs-3.5.3.tar.gz"
    sha256 "e48fabd87db8f3a7df7150a4a5ea22c546ee8bc39bc2473244730d4b56d2cc4e"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/ec/0a/cf955f8bb3b9498d554522cfe7cb9b019ba9f8b86e2879009f604207b72c/pydantic-1.10.9.tar.gz"
    sha256 "95c70da2cd3b6ddf3b9645ecaa8d98f3d80c606624b6d245558d202cd23ea3be"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/e3/12/67d0098eb77005f5e068de639e6f4cfb8f24e6fcb0fd2037df0e1d538fee/rich-13.4.2.tar.gz"
    sha256 "d653d6bccede5844304c605d5aac802c7cf9621efd700b46c7ec2b51ea914898"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/39/e0/d3803be771b215c45d2f4c61c7d073f1c9cb44099d2b391859486f20cfde/textual-0.20.1.tar.gz"
    sha256 "51d668ed5b2422e20ae29f506d52fd2c52fa254fb80e85a01ef08aa5d616ab9f"
  end

  resource "textual-autocomplete" do
    url "https://files.pythonhosted.org/packages/c3/4f/6c5917fdf9bfa0c18dfd3828ac70df6b5ddee9dd3b403d774447e1c0fec5/textual_autocomplete-2.1.0b0.tar.gz"
    sha256 "ba31da6e9b77e4c35323c267f958f0b90e1c2ddeca9c825c7d6c29d4d33893ce"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    refute_empty shell_output("#{bin}/ddqa config find")
    config_output = shell_output("#{bin}/ddqa config show")
    assert_match "repo =", config_output
    assert_match "[github]", config_output
    assert_match "[jira]", config_output

    assert_match version.to_s, shell_output("#{bin}/ddqa --version")
  end
end
