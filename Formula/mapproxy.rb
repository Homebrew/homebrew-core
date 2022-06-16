class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/db/98/d8805c5434d4b636cd2b71d613148b2096d36ded5b6f6ba0e7325d03ba2b/MapProxy-1.15.1.tar.gz"
  sha256 "4952990cb1fc21f74d0f4fc1163fe5aeaa7b04d6a7a73923b93c6548c1a3ba26"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a67990b6cae1a62b8bd22c0034c2d846cc51305f029ce2a0ff935a3fb4b0233b"
    sha256 cellar: :any,                 arm64_big_sur:  "3941b1ddb52dfde608a8116588b695a37b9003cec1bf8a21f71f642e5161a4f8"
    sha256 cellar: :any,                 monterey:       "70f01371595e686a9244655e0c5e5682a83720247b07db8c00cc266b5f1a88e3"
    sha256 cellar: :any,                 big_sur:        "2f93d2df55a61d86b4c246d842dad5d36c43716caef1ff996212fd439a229b14"
    sha256 cellar: :any,                 catalina:       "c83481e63a7b6eae74f6f5963041bf7f8fa08c19b5df52670f515bdd5fc41107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60402f962e783b1863afe3ab984b204d45337822acfdbafcfe255b14198af8ed"
  end

  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.9"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/07/10/75277f313d13a2b74fc56e29239d5c840c2bf09f17bf25c02b35558812c6/certifi-2022.5.18.1.tar.gz"
    sha256 "9c5705e395cd70084351dd8ad5c41e65655e08ce46f2ec9cf6c2c08390f71eb7"
  end

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/e3/4d/348402c2fb0d8a8e85a88b8babc6f4efaae9692b7524aedce5fddbef3baf/pyproj-3.3.1.tar.gz"
    sha256 "b3d8e14d91cc95fb3dbc03a9d0588ac58326803eefa5bbb0978d109de3304fbe"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end
