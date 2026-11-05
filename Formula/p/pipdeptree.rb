class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/5e/a4/a56387874fb7d739258609fc475e6ea10dad173415f30f8edb19894318b4/pipdeptree-4.2.14.tar.gz"
  sha256 "f1232630665aec3401328106cb8bb1f3f89cdacac94b3a7a7ba8b4ea21b3c612"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a4df37a5b804d7b365859d2c0a0550b6cdba85ab4e3dfdf821031ed83337f7f4"
    sha256 cellar: :any, arm64_tahoe:       "a5b7414505c700a4ae97ee3ca964492fdd29220bb0905c247ebe936c948a6589"
    sha256 cellar: :any, arm64_sequoia:     "803794a0da8cce56702b225d46fb8310039cb9c14e7a1ac49521dee26eb47cca"
    sha256 cellar: :any, arm64_linux:       "7f20fba5bb25b2155f228ce19c716c033d33f66cd6a7549f7f139df84c37a51f"
    sha256 cellar: :any, x86_64_linux:      "f8e956397f6678d408a816a0f08915c64c9dee02675555b56eec871868b9b03e"
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
    url "https://files.pythonhosted.org/packages/bc/1e/eecba2176fca5c9b7193b93487b963e90e59122f254ba4fbfcba22d05487/nab-0.0.25.tar.gz"
    sha256 "47767b6b9bb6d94aeedb5d9a6056353789e98666121b9198bb686c3684134899"
  end

  resource "nab-index" do
    url "https://files.pythonhosted.org/packages/e8/eb/5a27af36e8389c44d8575f47ae7dc1995111e5199cef2e92142b96328ea2/nab_index-0.0.25.tar.gz"
    sha256 "3de999cf43db126687177d80bb6edff9e256d319038fe629a6667afdaa456ccd"
  end

  resource "nab-markersets" do
    url "https://files.pythonhosted.org/packages/89/36/13e9c5f531e2ceef31aceb68fe68f428424a86ec5e257dc958c4361f27cc/nab_markersets-0.0.25.tar.gz"
    sha256 "7081ab03eafaa463f17b885de3401cd1e943396148074d8e648738ddb8532052"
  end

  resource "nab-project" do
    url "https://files.pythonhosted.org/packages/1a/74/33e1770074b46de3a5ea6a70b0e07302260f16615368889a3fe909ffe8ca/nab_project-0.0.25.tar.gz"
    sha256 "c9c69da60f8780bf7211565aa665d4530c2de91364ef697960c7dd5be2f86fe3"
  end

  resource "nab-provider" do
    url "https://files.pythonhosted.org/packages/9c/45/20616982c47d5d0d2c314769d2c924aa101b929dc1f6d74cd31303552098/nab_provider-0.0.25.tar.gz"
    sha256 "e1bd1ce7f99987a344e558fc465b58ab7c9ba61b560419030f683be78d6dca25"
  end

  resource "nab-resolver" do
    url "https://files.pythonhosted.org/packages/30/7c/3ea09ff7526ec2bb1f39a9ff378e1701284cf0041656e9233c20aac50a89/nab_resolver-0.0.25.tar.gz"
    sha256 "2b6c4eeb14e8a45951411a31c8e484d58b7b96b22293be3fb13d410122dee325"
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
