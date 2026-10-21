class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/7e/43/23b74c4767c90d33271cd8197847c2f58f5ae6372c145127e4ddf3520e4d/pipdeptree-4.2.9.tar.gz"
  sha256 "58c6557df033e6cb923103e5e07938f4b3397371ac6e155f714b1dc2d462806d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "23be1d29250f43cca59dcb9c2504e4f6335bf1e5a237bb4f6f5b68e9304f80d1"
    sha256 cellar: :any, arm64_tahoe:       "ba423a6a8a407f19a8eebf39f0461f46fde46f7053b184730c2fa422b1d0156d"
    sha256 cellar: :any, arm64_sequoia:     "084b0dbfc49bd6de359bc7e6963566df6f98d2b2040e66eff2dd15cac9443f4f"
    sha256 cellar: :any, arm64_linux:       "08aaba3228fdb06269c8f572de65c47672d89ef27bcc669e5908a35dad79c9f3"
    sha256 cellar: :any, x86_64_linux:      "0234a1dfed8ab734252553c5fd8b6d62bcbacbcdbaba0ee8509ef4385cce36e7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "python@3.15"

  pypi_packages exclude_packages: "meson",
                extra_packages:   "meson-python"

  resource "build" do
    url "https://files.pythonhosted.org/packages/bd/67/4898a44ea4f3f8e213b0954ec0aa0a16971d62a6212d6ea3931e97115b99/build-1.6.1.tar.gz"
    sha256 "51cc11666391ab6f092070437ac747002ff46f3e4113a3622177ee6b488bfc53"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/56/d3/2fab33d15004d41ae8e7b5d3e310510f7f34a7e1dd032a3e60d8b38d8fba/installer-1.1.0.tar.gz"
    sha256 "5adc0c01ce62d809989e246987cd68944fe5df8af562d0358f65b2ab15cb5de7"
  end

  resource "meson-python" do
    url "https://files.pythonhosted.org/packages/b4/40/343ae23722d5d66a7b94b752d1b194202640995296379333b274b1860871/meson_python-0.22.1.tar.gz"
    sha256 "52c88628b0e5671592dc2306613fb5f6f3615fd24def059b9894f143b7f9a139"
  end

  resource "nab" do
    url "https://files.pythonhosted.org/packages/25/3d/e4c8f4b2890efbf2fa6eef82acf57ecc0ef39b0a1e6843d306d2053a107c/nab-0.0.22.tar.gz"
    sha256 "a0da54ee96bf1eb1997581566620c250c8a3557139e9467ccaced2a12e9e71ac"
  end

  resource "nab-index" do
    url "https://files.pythonhosted.org/packages/2a/83/8d2483239b7dc5ac8d9f758db1cc19d4129d0143d34c2e1ab8cd48ea71fb/nab_index-0.0.22.tar.gz"
    sha256 "5900ea5ad298512379cfddff1a73a544590f0b04620ef58ff345f99a7c59688e"
  end

  resource "nab-markersets" do
    url "https://files.pythonhosted.org/packages/fc/b7/3997893dfdada9998d4dc786c10445a1361e197b4aed54ddd866c84dd538/nab_markersets-0.0.22.tar.gz"
    sha256 "38212664f517f75d798808ecfe902bfd11fef340042ab0203100c7e06e78eea5"
  end

  resource "nab-project" do
    url "https://files.pythonhosted.org/packages/65/84/f5197d4044ceda9c6ee3e7aefce154ab616fec632fa1d89cdfaacc665c07/nab_project-0.0.22.tar.gz"
    sha256 "5f7a1dee5b618149267b2b6233c3a220e45cd6f97bd5ec7f3f48fa7570e9f053"
  end

  resource "nab-provider" do
    url "https://files.pythonhosted.org/packages/94/0d/64fbadae562fefc00257c4f5ec988171d6e6b3ea4363f1da2e8886e80228/nab_provider-0.0.22.tar.gz"
    sha256 "3f129ab7394bf5eb031152c3535ee74073e2a6b6ae081fb7f5a4d269fcf5f8a0"
  end

  resource "nab-resolver" do
    url "https://files.pythonhosted.org/packages/84/bc/dcbfe5163538b1cc8421797e3f8ff77d79321cbc9943af8065e2c8ae1c09/nab_resolver-0.0.22.tar.gz"
    sha256 "e005b225213e032858cf4aef3850961aaa1d4ea521428da731f33175ebd3b05f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/6d/5d/f2ddeef4a855a102aaae5e97826a0260007522ab504421b75addfdb1517c/pyproject_hooks-1.3.3.tar.gz"
    sha256 "defda19b854fa0d3bd4f76ea4ddcba8abd7dcfcdd585a6690ade050744fc5f43"
  end

  resource "pyproject-metadata" do
    url "https://files.pythonhosted.org/packages/4f/76/1cae539918a7b1746d624c2f01560b793c22cd8c081157505bb9bbf0e34d/pyproject_metadata-0.12.1.tar.gz"
    sha256 "8809a4df6fe08279b39a8890669506ed3158e0617855ac9aff098fcbe772ae4c"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/b0/78/9ad63712633ed3ab5cc1a648d863d7e7da371e9425e209555a0fe711b695/tomli-2.5.0.tar.gz"
    sha256 "264507556cd8b8c8e7c6ee037cdf443a463f03f4c958e57195e3d369711b8ff6"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.reject { |r| r.name == "meson-python" }
    # meson-python self-hosts via backend-path; without isolation it uses brew meson and ninja
    venv.pip_install resource("meson-python"), build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
