class GlobusCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to Globus"
  homepage "https://docs.globus.org/cli/"
  url "https://files.pythonhosted.org/packages/4d/c6/0b0f5482eed6600e3110e41298bea7982fec708910401f2d0b74f18ffff6/globus_cli-3.44.0.tar.gz"
  sha256 "44881798eeeff7c41a56997c48c7d0de4ba9ac3149cbdd5125f4dfea43d6375a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "89ca8b216e03917813554bbda7b4e3d27ae22e6a7fee9478d9a61beb06d4a939"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.15"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "globus-sdk" do
    url "https://files.pythonhosted.org/packages/a9/78/9d61118c9aa81b29779ab8f2101cd9fc9f2fc00d240bf626ba6d5d305b7a/globus_sdk-4.9.0.tar.gz"
    sha256 "41cdc8611e6d48133fc75e20162068c8ad583a63f33245bd2e2d64edd6425a71"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"globus", shell_parameter_format: :click)
  end

  test do
    assert_match "globus transfer", shell_output("#{bin}/globus list-commands")

    output = shell_output("#{bin}/globus whoami 2>&1", 4)
    assert_match "Missing login for Globus Auth", output
  end
end
