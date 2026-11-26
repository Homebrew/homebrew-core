class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://docs.ansible.com/projects/lint/"
  url "https://files.pythonhosted.org/packages/61/30/07fcc88e71584f3804b3cd498903f6f71454cb0efe7c084bdd48e9837ff5/ansible_lint-26.11.1.tar.gz"
  sha256 "4264fcad6c1e9eb4f1d8ee369302d0d908e9397338f3fb20814071cae5ad2d4f"
  license all_of: ["MIT", "GPL-3.0-or-later"]

  bottle do
    manifest_sha256 "6a0f537ec8622b2c0ea01b697ef76872954621da2911249695daa985f76a735d"
    sha256 cellar: :any, arm64_golden_gate: "a0ab4a16aaba3829feccd36dc06a949790dcc71c6af11457792a25668f279c47"
    sha256 cellar: :any, arm64_tahoe:       "1638d995652ebfb994a19640d0dd75e1f63b815d9c477796dd9463e0a77670ca"
    sha256 cellar: :any, arm64_sequoia:     "2b78b53dbddea85a4516829823a936eeff9a1ee889469e18c75668cfd597fa97"
    sha256 cellar: :any, arm64_linux:       "b70c9dba16fc882235473aecd7953b9b098da81a71234178c1f13c9707f0c650"
    sha256 cellar: :any, x86_64_linux:      "a47be6889150fce5a255ef39461b1bc001331c1b9f9cf03b6d1eae753dd68d07"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ansible" => :test
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: %w[cryptography rpds-py]

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/58/4e/52311092d3168346557c31d1090225cc57dbe48ecc399c2e400da4c6065f/ansible_compat-26.11.1.tar.gz"
    sha256 "d22e0a48d8d79e727b0f56db3573b02bde2189b5bfbef067230a34c0bcbff94a"
  end

  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/9d/9c/320090b2f1542122259cd759d5148678fd98945913837ee05718920f73ea/ansible_core-2.22.0.tar.gz"
    sha256 "bf50b4a0cfa985e30585c7ba301897ea7050d224ca49d2816cab10e33a160e1c"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/f8/65/a9611a6ec0a8c88d86e59385da02d68d9533f7e86a05913d20c67be54029/black-26.10.1.tar.gz"
    sha256 "5f9f83beae62437e060dafd53d7f1fc327e3d3494f74d72ee5c2b73eb90fc4e7"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/66/6f/95a6fcb1c430007cda4122c77aace4541fba297f08e2be791ab235a4c548/bracex-3.2.4.tar.gz"
    sha256 "c1e67eb59f81445dee15b2c588b7c81352b697cfbd6c4931a2943ea6b71eb5ea"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/e6/86/a5b9ec254b90efb180e390e31a4fa50a93b714d6e4174fa9a4ee25607159/filelock-4.3.1.tar.gz"
    sha256 "4c5ee627c401f1863ac6a0de9a14a28d3bb5f8c730b45e2fd6e5dbc79cf34b9e"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/d0/6f/43edf3be2748d0e40974a5ee046a8bb4c9961a4bdd3e7d5c6dcbf32d1af6/mypy_extensions-1.2.0.tar.gz"
    sha256 "c6e275a07f1c2fc096b62940452d0eaa3f3af7de45d704787866240a7c6d5a51"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c3/75/ffb1dc0ed12352139fb4ca0e3fde4325a23e3d0f3f40efe89717bc4f557b/packaging-26.4.tar.gz"
    sha256 "c4b671c41ddb9bf26e543c37723610d28fb6bf7affc4da17cf048d419d2c062a"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/71/18/0b0d99f5bf164f04a7a9534c3dbdbe4d5fd2b382667685ad40c192c4d3d1/platformdirs-4.14.8.tar.gz"
    sha256 "96893d686e84e9e6f358a9ea41a8de544df66dbf2ba6cda250e7dc73acf85b9b"
  end

  resource "pytokens" do
    url "https://files.pythonhosted.org/packages/b6/34/b4e015b99031667a7b960f888889c5bd34ef585c85e1cb56a594b92836ac/pytokens-0.4.1.tar.gz"
    sha256 "292052fe80923aae2260c073f822ceba21f3872ced9a68bb7953b348e561179a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/76/b8/c0b780928e2fb1c87e9e375818c6f121da2398b071012d1747be300b83f4/pyyaml-6.0.4.tar.gz"
    sha256 "e24bf71af8a432d7808fabff134d38dfe16d3cbb41f2873bb4b1e42422de0a1a"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/1d/14/4669927e06631070edb968c78fdb6ce8992e27c9ab2cde4b3993e22ac7af/resolvelib-1.2.1.tar.gz"
    sha256 "7d08a2022f6e16ce405d60b68c390f054efcfd0477d4b9bd019cc941c28fad1c"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/d7/22/991efbf35bc811dfe7edcd749253f0931d2d4838cf55176132633e1c82a7/subprocess_tee-0.4.2.tar.gz"
    sha256 "91b2b4da3aae9a7088d84acaf2ea0abee3f4fd9c0d2eae69a9b9122a71476590"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/96/3a/fd5e95b2c1c04e3874682f9796d06f7389e2a95ab581177800ca17e785fa/wcmatch-12.0.4.tar.gz"
    sha256 "23fe77fbfa3fff9e46f0f4a3d1891065270596774bd6131bd2f973fb822242a1"
  end

  resource "yamllint" do
    url "https://files.pythonhosted.org/packages/28/a0/8fc2d68e132cf918f18273fdc8a1b8432b60d75ac12fdae4b0ef5c9d2e8d/yamllint-1.38.0.tar.gz"
    sha256 "09e5f29531daab93366bb061e76019d5e91691ef0a40328f04c927387d1d364d"
  end

  allow_network_access! :build

  def install
    virtualenv_install_with_resources
    rm(bin/name)
    (bin/name).write_env_script libexec/"bin"/name, PATH: "#{libexec}/bin:${PATH}"
  end

  test do
    mkdir ".git"
    output = shell_output("#{bin}/ansible-lint --version 2>&1")
    refute_match "WARNING", output

    ansible_lint_core_version = output.match(/ansible-core:([\d.]+)/)[1]
    ansible = formula_opt_bin("ansible")/"ansible"
    assert_match "[core #{ansible_lint_core_version}]", shell_output("#{ansible} --version")

    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~YAML
      ---
      - name: Homebrew test
        hosts: all
        gather_facts: false
        tasks:
          - name: Ping
            ansible.builtin.ping:
    YAML
    system bin/"ansible-lint", testpath/"playbook.yml"
  end
end
