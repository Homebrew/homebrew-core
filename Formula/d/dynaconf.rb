class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/fc/24/23ffca4bfb74ee9ddc0a3b1fbae401a6ee3c02700ec457ddceffffce1ad9/dynaconf-3.2.4.tar.gz"
  sha256 "2e6adebaa587f4df9241a16a4bec3fda521154d26b15f3258fde753a592831b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "427833190e822ce48bb7dd7bb5513d58a387ba9e3f38b73a7965ec8de843a375"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98ff845033e109c5424ed14809d8ed664953f07e3e0958665152fa6f773c5a94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93ba7f5b76b04be94ffcb6b419bb24d619a4813ccbd591566839e4c19815290e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff9196a08cc0340627ae7b1524b85aaea0a8d4ebb32c4c71a9bc1a1a07e7d2bf"
    sha256 cellar: :any_skip_relocation, ventura:        "2d36216d5efc117e1da3941d08cd65bd50578e412a5c14bbe57b18ff7c37ef8d"
    sha256 cellar: :any_skip_relocation, monterey:       "c3b7f445e12dcfd435598f6997619fee447dacdc16d2cc29d75b4f3d341609df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "819b86fe3d17778b1073b71bb368e15833dde49820f098b898c3275c4351cb4a"
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
