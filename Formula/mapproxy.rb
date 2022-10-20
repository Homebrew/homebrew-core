class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/db/98/d8805c5434d4b636cd2b71d613148b2096d36ded5b6f6ba0e7325d03ba2b/MapProxy-1.15.1.tar.gz"
  sha256 "4952990cb1fc21f74d0f4fc1163fe5aeaa7b04d6a7a73923b93c6548c1a3ba26"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "1f7f76b227e635e78179db1da2ec4f2c57dd8a752bafcc65d33c5282c399c9fd"
    sha256 cellar: :any,                 arm64_big_sur:  "e894d1e3e137da8dc77cceda200b2d832fde3db82d579785ac63b5b7098c223c"
    sha256 cellar: :any,                 monterey:       "50214110fd2799c5915f9eb3a9caa2159d4e8f3688c2cab1d002ce7e81e49927"
    sha256 cellar: :any,                 big_sur:        "9afb0314606e933b86395c1f38b69e8d9c30e28fe7e266f50d4a3f7d27844c35"
    sha256 cellar: :any,                 catalina:       "8a8f9bc035f068eacc11e81546e88897c239e66c170858801c98a0e2b56fa592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c5f11427dadc77c24a18fe1a5ff550107ee0ee940975aeee8ecd75b5f468839"
  end

  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/07/10/75277f313d13a2b74fc56e29239d5c840c2bf09f17bf25c02b35558812c6/certifi-2022.5.18.1.tar.gz"
    sha256 "9c5705e395cd70084351dd8ad5c41e65655e08ce46f2ec9cf6c2c08390f71eb7"
  end

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/e3/4d/348402c2fb0d8a8e85a88b8babc6f4efaae9692b7524aedce5fddbef3baf/pyproj-3.3.1.tar.gz"
    sha256 "b3d8e14d91cc95fb3dbc03a9d0588ac58326803eefa5bbb0978d109de3304fbe"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end
