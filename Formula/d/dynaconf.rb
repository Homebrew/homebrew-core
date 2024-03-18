class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/3b/1f/577263ba18254578b7235b2b1ea55e1a62ca537d3acfc3033e93a9631759/dynaconf-3.2.5.tar.gz"
  sha256 "42c8d936b32332c4b84e4d4df6dd1626b6ef59c5a94eb60c10cd3c59d6b882f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3de5f9073989529dfebb6da92aeecdba30882c9ced08dd9e92bf12708afa20af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3de5f9073989529dfebb6da92aeecdba30882c9ced08dd9e92bf12708afa20af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3de5f9073989529dfebb6da92aeecdba30882c9ced08dd9e92bf12708afa20af"
    sha256 cellar: :any_skip_relocation, sonoma:         "3de5f9073989529dfebb6da92aeecdba30882c9ced08dd9e92bf12708afa20af"
    sha256 cellar: :any_skip_relocation, ventura:        "3de5f9073989529dfebb6da92aeecdba30882c9ced08dd9e92bf12708afa20af"
    sha256 cellar: :any_skip_relocation, monterey:       "3de5f9073989529dfebb6da92aeecdba30882c9ced08dd9e92bf12708afa20af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bae742fc1d2b99d307784f348459c20c33b6535f28b737f3df1171a1e6f41a1"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
