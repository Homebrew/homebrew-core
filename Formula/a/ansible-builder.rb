class AnsibleBuilder < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for building Ansible Execution Environments (Containers)"
  homepage "https://ansible-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/fe/6b/0525894e5dd510c3a67da0b8819209333ca939cfa94b7f0d3ef041a628ec/ansible_builder-3.1.1.tar.gz"
  sha256 "9d88bc15acc7d31056d0c51914a6102dac8e5ad73f9f2d35ba98378c89714ed2"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a3c7948caddd81ba892ad8c0ac781b33d26aaaa0f884f035af192fd523fdd43d"
    sha256 cellar: :any, arm64_sequoia: "b8b984f597adeebaea844aa67d8d2b9f98289f98fd1a681399156ce2c7b02a10"
    sha256 cellar: :any, arm64_sonoma:  "89a2129d196ad564997ff6825672a1213f3296d9ec925c47e13db4460e67f661"
    sha256 cellar: :any, sonoma:        "5e959e4f95270a8e9a1a9951ae86278e239e2b07d713cc60454ce725259f66a2"
    sha256 cellar: :any, arm64_linux:   "b6157ba9546a46a72aa44758a12240cfc6e4af81b1b5cd465fb98fc641c24130"
    sha256 cellar: :any, x86_64_linux:  "678f255237e8825954cc8dad01272a881729f1486c96ffa01cd3202903b5d59a"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: "rpds-py"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "bindep" do
    url "https://files.pythonhosted.org/packages/be/c2/a549e0286fd2711e401dc240184fb89c06e2ff1642fb7c6cac7a95fe0c8c/bindep-2.14.0.tar.gz"
    sha256 "0c804c7e48dd17db24cb39121ade7171f684fb463c8aa01d0338cd11d254364a"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "parsley" do
    url "https://files.pythonhosted.org/packages/06/52/cac2f9e78c26cff8bb518bdb4f2b5a0c7058dec7a62087ed48fe87478ef0/Parsley-1.3.tar.gz"
    sha256 "9444278d47161d5f2be76a767809a3cbe6db4db822f46a4fd7481d4057208d41"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/5e/ab/1de9a4f730edde1bdbbc2b8d19f8fa326f036b4f18b2f72cfbea7dc53c26/pbr-7.0.3.tar.gz"
    sha256 "b46004ec30a5324672683ec848aed9e8fc500b0d261d40a3229c2d2bbfcedc29"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_tmp = testpath/"tmp"
    (testpath/"execution-environment.yml").write <<~YAML
      ---
      version: 3
      images:
        base_image:
          name: quay.io/ansible/awx-ee:latest
      options:
        skip_ansible_check: True
    YAML

    system bin/"ansible-builder", "create", "-c", test_tmp,
      "--output-filename", "Containerfile",
      "--file", testpath/"execution-environment.yml"
    assert_path_exists test_tmp/"Containerfile"

    assert_match version.to_s, shell_output("#{bin}/ansible-builder --version")
  end
end
