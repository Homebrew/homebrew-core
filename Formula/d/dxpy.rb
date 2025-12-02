class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/89/f8/5658fdfc25706423eef3f6e1fcf1604e4a187e4349ee063d5604ec9f9f5d/dxpy-0.400.1.tar.gz"
  sha256 "c91666c960675426e63e1815d53009f14fcee9c2b661a529e9e40c3d068f44ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54b95396e27ea9233ac0e7d0e7f14455d98d49f6000de24f34647580fbee41d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad418433a4bb59d969354de84090b5a5eab13b5133110d74f1376176a8fb0e5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8edb84b9598ab96111c70f4a29a1f7f177caff1a9405c54c224d679a5bca9ee1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2655b0bf2b535025f4c197508f30ea5bb26c9296d5cc11df760b9e3c2f5a3b66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9296e0209a0dfa78c335c1fd586ab71d6e872c37df744428078289b6752d4ee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb73d410c0043281050b9703ded3a34f9e48a74d3c07f6c0c44ce3e88e14f88b"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.14"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  pypi_packages exclude_packages: ["cryptography", "certifi"]

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/e3/66/7e97aa77af7cf6afbff26e3651b564fe41932599bc2d3dce0b2f73d4829a/crc32c-2.8.tar.gz"
    sha256 "578728964e59c47c356aeeedee6220e021e124b9d3e8631d95d9a5e5f06e261c"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/88/bdd0a41e5857d5d703287598cbf08dad90aed56774ea52ae071bae9071b6/psutil-7.1.3.tar.gz"
    sha256 "6c86281738d77335af7aec228328e944b30930899ea760ecf33a4dba66be5e74"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/20/07/2a94288afc0f6c9434d6709c5320ee21eaedb2f463ede25ed9cf6feff330/websocket-client-1.7.0.tar.gz"
    sha256 "10e511ea3a8c744631d3bd77e61eb17ed09304c413ad42cf6ddfa4c7787e8fe6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    dxenv = <<~EOS
      API server protocol	https
      API server host		api.dnanexus.com
      API server port		443
      Current workspace	None
      Current folder		None
      Current user		None
    EOS
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end
