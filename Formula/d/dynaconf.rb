class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/fc/24/23ffca4bfb74ee9ddc0a3b1fbae401a6ee3c02700ec457ddceffffce1ad9/dynaconf-3.2.4.tar.gz"
  sha256 "2e6adebaa587f4df9241a16a4bec3fda521154d26b15f3258fde753a592831b6"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d8106235c4e6600c2881159d18115183ba137485a73767ad135afadb0a246eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e10d7fb9bec5e2d40690fd6806a92fdce82414651c344e40c2e713a342c88d84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "646911bd8b5387db8a4e8d9b842b174abb37f7495c7a436a50c69b1307c1cfdd"
    sha256 cellar: :any_skip_relocation, sonoma:         "d15b93c4336f01141730cdfb9e775f00fe233d237de842eb12a3dcad95ae5cce"
    sha256 cellar: :any_skip_relocation, ventura:        "69b316214ec2eff3d8b47936e65ada02c0768be86fc64861c0b0918646598e27"
    sha256 cellar: :any_skip_relocation, monterey:       "213353cc623530b4c72ad55fa495a43aa22025ab56914fb7d2ff5454884f5fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "678f2af6fbd07b7de707d1deb8abef0a6bf918a229d3315fd4afd96034e418c8"
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
