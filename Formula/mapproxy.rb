class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/db/98/d8805c5434d4b636cd2b71d613148b2096d36ded5b6f6ba0e7325d03ba2b/MapProxy-1.15.1.tar.gz"
  sha256 "4952990cb1fc21f74d0f4fc1163fe5aeaa7b04d6a7a73923b93c6548c1a3ba26"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2396ba7893fa3d7b0831ebb18533a2f73c8f6e4b30e61ca0eb38641f19ad1a5f"
    sha256 cellar: :any,                 arm64_big_sur:  "7cb053b16e7c06746d420c410797e9c294311fd1213000e5485f6aa2c99b9dee"
    sha256 cellar: :any,                 monterey:       "c4fdec843abd2a725d2a6ed834a1122dd55bca8441f68373a90ae44afbadef90"
    sha256 cellar: :any,                 big_sur:        "92b661037da1ad2a9981f194325f43ecc15c27f11e09bd375ad5cc7bba0c73e8"
    sha256 cellar: :any,                 catalina:       "3b1adaa856106a10da076232b6c33a0fbce2971199cc6b09926a39cd34e3533e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b74e416776f291996c52dd4e195be77b7154107d3102cf7d1c49be9cd5d947ff"
  end

  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.10"
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
