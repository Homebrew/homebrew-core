class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/19/46/20ca1d51ec287be3de393a6b16da7462469b428158e045ba1f37caeed8ab/pipdeptree-4.2.15.tar.gz"
  sha256 "634d078d54644046bfb5416c39423cf594430a2f59f94e89c7152e0efdb02c23"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bca03bed26c48f4d89f608c2bdcc60316fadd2484e4c9d608a5f65114c5cbe70"
    sha256 cellar: :any, arm64_tahoe:       "72b18cafef4bca30e936f4166bbd24dbd767d912eb0e851016446edf1ee8ed63"
    sha256 cellar: :any, arm64_sequoia:     "e4202ae98160003faf526eab05038f49b91b391f295024c61c476a77c65845ef"
    sha256 cellar: :any, arm64_linux:       "5882444297ba8f2736879ed6d0aab929c2dbea5f836b924e2e6851e62558a422"
    sha256 cellar: :any, x86_64_linux:      "f420b3b1368857c0383d2bb299fe941ee127fd22bf3151366dbf682cb617fb3a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "python@3.15"

  pypi_packages exclude_packages: "meson",
                extra_packages:   ["meson-python", "python-sbom"]

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
    url "https://files.pythonhosted.org/packages/ce/4f/b0206effc0591650c5ec7d183291d5ddd1f6e10d3f3113e3173e9bcd8c61/nab-0.0.30.tar.gz"
    sha256 "19aa82047b630b583eb9b8fa86a95e8f428fd020bc91e3088dded45347ad43da"
  end

  resource "nab-index" do
    url "https://files.pythonhosted.org/packages/97/0c/94b4d400f2351f4ad448fce58db548a8ac934b361d908088483047e16ba9/nab_index-0.0.30.tar.gz"
    sha256 "64051ea29c1134ff1113d26c9c1e773214341a5d447efa542d09c0ab39448ff7"
  end

  resource "nab-markersets" do
    url "https://files.pythonhosted.org/packages/1c/e2/dc80dd10beacb645611b760a8544082c05ae5530cbb527faa251d044c5e5/nab_markersets-0.0.30.tar.gz"
    sha256 "acebebe1a2c5f2cdf0d251e386af88bda9221a36750fcc8a258d8de8c34bfae5"
  end

  resource "nab-project" do
    url "https://files.pythonhosted.org/packages/ca/43/e2da76aa27fb442934aee6a2a76a3b7023b19b4eb5fd737432aaae35012a/nab_project-0.0.30.tar.gz"
    sha256 "6d9d427c765b6283b4054974b8b3e6b23b8850fa18dd9caf843885b689a292bf"
  end

  resource "nab-provider" do
    url "https://files.pythonhosted.org/packages/49/df/7f27b3a2e33e26bc662ed322e123af86ff79a33a849fd35e5217264e17b4/nab_provider-0.0.30.tar.gz"
    sha256 "4bcb3b3687896484d6d824a0345b66293423fd074dd7f6815d9535a52017cffd"
  end

  resource "nab-resolver" do
    url "https://files.pythonhosted.org/packages/01/eb/6016fd6b461ab3241675ffac399c62b33012a1612ed18a58c13591b62b71/nab_resolver-0.0.30.tar.gz"
    sha256 "27e62075229cc0020a879a84c60d1de1c4a92f0150e0a830e21b8ea83cffe948"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/f5/d6/3b5a4e3cfaef7a53869a26ceb034d1ff5e5c27c814ce77260a96d50ab7bb/packageurl_python-0.17.6.tar.gz"
    sha256 "1252ce3a102372ca6f86eb968e16f9014c4ba511c5c37d95a7f023e2ca6e5c25"
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

  resource "python-sbom" do
    url "https://files.pythonhosted.org/packages/e7/c8/433fce09ca6d9580e71b1bcde4db4da5c1f77039536deca9d373f1b7886e/python_sbom-0.3.1.tar.gz"
    sha256 "37d0fa3d0a16fddc3d88099e147e164ddb3055e8bc3424506ef41dd80f723a73"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/b0/78/9ad63712633ed3ab5cc1a648d863d7e7da371e9425e209555a0fe711b695/tomli-2.5.0.tar.gz"
    sha256 "264507556cd8b8c8e7c6ee037cdf443a463f03f4c958e57195e3d369711b8ff6"
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

  resource "zipremove" do
    url "https://files.pythonhosted.org/packages/92/30/47d65b9213f52df8a51f603cb0a2e5ef02c22172a8a17805e46c3beabb0d/zipremove-0.10.0.tar.gz"
    sha256 "3c5957c115447b54299d3a23128764b59c4558fc98c4b878ff2dbc5db8a62021"
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
