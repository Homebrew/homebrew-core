class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/07/44/dfea2b1b83c418a2c6291bc4d490044d5a74316fb2201bd38fd8809dec3a/dxpy-0.380.0.tar.gz"
  sha256 "e3fb70b283a9eda2f861d6b85322841d78b2655cd7de11f1e946643b58de3d4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03a2df5b81de351a962b6b36bcfc514dfb9ee6c0ae35eb2b7f95938d8ed7c0ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c2ded6aac819aec8ee1a036540a37c4043c8da6eb89db113e870770c053cfb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22a1ab36eac5deffd79e0032b1408df52f145a1e153d54abe477072b4bed1147"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bbe46bca442ebf179ba1f42403841609dcbc628a8fd3c455a2514689fbc0dc8"
    sha256 cellar: :any_skip_relocation, ventura:        "f6d9a93e494845270738bc7a7d19e411b348f1d8f847511b973a8dca3affd182"
    sha256 cellar: :any_skip_relocation, monterey:       "1eca886f8f6769a2acc1b4f0a68adaff5a9deb75688010c74f7bc82ab63bc552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91ab26090cf3a0e62188021b68318c4fe6c51201d0a9487d66abada0ea533037"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/db/ca/45176b8362eb06b68f946c2bf1184b92fc98d739a3f8c790999a257db91f/argcomplete-3.4.0.tar.gz"
    sha256 "c2abcdfe1be8ace47ba777d4fce319eb13bf8ad9dace8d085dcad6eded88057f"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
