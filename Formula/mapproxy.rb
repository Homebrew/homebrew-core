class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/98/3b/424fecff5f852100a100e326cc554df17da59d491d3c62fd305caceffcf8/MapProxy-1.14.0.tar.gz"
  sha256 "dd36278d60cdcaaf31f7f9bbc50e90e770f3feb65cf4b3eff287215ee85f018d"
  license "Apache-2.0"

  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.9"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/e4/36/c151d658ca1a1ccfd5ed82ac3b41d13c36cbd0687da97ac1beaeb3381fa8/pyproj-3.3.0.tar.gz"
    sha256 "ce8bfbc212729e9a643f5f5d77f7a93394e032eda1e2d8799ae902d08add747e"
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
