class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/94/37/19bc53fd63fc1caaa15ddb695e32a5d6f6463b3de6b0922ba2a3cbb798c8/autopep8-1.5.4.tar.gz"
  sha256 "d21d3901cb0da6ebd1e83fc9b0dfbde8b46afc2ede4fe32fbda0c7c6118ca094"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7a1af51be88ece857ffbee3b688ab5c76ac465dfe482e08d5db715f167348607" => :catalina
    sha256 "8e40c8850093551fbc71906ac70b6751558c87b9d1ff0e94da16e7fc2d03b8f5" => :mojave
    sha256 "2f945061a8ad72875f385cf2420c4065791b4d9923ecc0bfe6e99218b2fc7f9c" => :high_sierra
  end

  depends_on "python@3.8"

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
