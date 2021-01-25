class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/94/37/19bc53fd63fc1caaa15ddb695e32a5d6f6463b3de6b0922ba2a3cbb798c8/autopep8-1.5.4.tar.gz"
  sha256 "d21d3901cb0da6ebd1e83fc9b0dfbde8b46afc2ede4fe32fbda0c7c6118ca094"
  license "MIT"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a50d7391893a20c137ba971ef2119ab63f5ceaca21d35fee6e8bda5472a6c6b2" => :big_sur
    sha256 "ada2ccfd2662a8b51baca7ba6d8b7ac2d56615439d21f79014f2e596bbece49d" => :arm64_big_sur
    sha256 "8ee96be12db50876b59fd7527e5ac37e78956a1e0a7afee54c37606057b0512b" => :catalina
    sha256 "f988eb964253d539121936ee925466884bfd57adea919a642d926b5ee5c6188a" => :mojave
    sha256 "b0105ebba5fe631f32f32a097c15ac904f363746d5945c7d16f994e7dd0cb129" => :high_sierra
  end

  depends_on "python@3.9"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/bb/82/0df047a5347d607be504ad5faa255caa7919562962b934f9372b157e8a70/pycodestyle-2.6.0.tar.gz"
    sha256 "c58a7d2815e0e8d7972bf1803331fb0152f867bd89adf8a01dfd55085434192e"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/da/24/84d5c108e818ca294efe7c1ce237b42118643ce58a14d2462b3b2e3800d5/toml-0.10.1.tar.gz"
    sha256 "926b612be1e5ce0634a2ca03470f95169cf16f939018233a670519cb4ac58b0f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/autopep8 -")
    assert_equal "x = 'homebrew'", output.strip
  end
end
