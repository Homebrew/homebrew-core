class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://docs.ansible.com/projects/lint/"
  url "https://files.pythonhosted.org/packages/fe/55/94814bfe335b58e1f65c0b2e6c8d0676737eadd7cc1466d8fe7213345a13/ansible_lint-26.10.1.tar.gz"
  sha256 "a746c6f3cb5719d1c202bc14e956ef3b0eca704025d1aa92707a27fc73ed73ea"
  license all_of: ["MIT", "GPL-3.0-or-later"]
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2d1bc5555b077e708a41aede8f86498fddf3ed53994d5c743c31d7ce75d1e1e1"
    sha256 cellar: :any, arm64_tahoe:       "0f9523c927649eb22845e6141bad915097572a1c4285f09b826448901355b10e"
    sha256 cellar: :any, arm64_sequoia:     "deac1dd3ff6d3f70c2c024e981fa54defade2511cf727f034238a84be5d1c29c"
    sha256 cellar: :any, arm64_linux:       "2089febaa8a4e1f1ea665781609755dda76b7024b404e3db57536d3528d659d8"
    sha256 cellar: :any, x86_64_linux:      "2dd90417a1420cf5e0383af99d21ec9f3fde56ec27e0dcad69c1348e9851629f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ansible" => :test
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  # FIXME: remove `extra_packages` when `ansible` formula adds support for new `ansible-core`
  pypi_packages exclude_packages: %w[cryptography rpds-py],
                extra_packages:   "ansible-core==2.21.6"

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/e8/b3/64652d98718d5a597a15c2eb95e55fd6935b1c4eeee316370e5a498a2a6e/ansible_compat-26.11.0.tar.gz"
    sha256 "35cbe829e0b5a9acb85d34b8d5da2eb45acaf767f6651f90e0ab2f3a96a060bb"
  end

  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/ed/9f/c3f578633cd374db6ed981f8abc401885819e94e3d6a8548a1bd0095c575/ansible_core-2.21.6.tar.gz"
    sha256 "3fa05b4b1af69f2fa19b49dde8edd5a23e693c2c1c3bda2d85fce73bd6cfc36d"

    # Python 3.15 startup fix, upstream PR ref, https://github.com/ansible/ansible/pull/86976
    patch do
      url "https://github.com/ansible/ansible/commit/ee5c59156c61bc1f452a61846138e0d40427aeab.patch?full_index=1"
      sha256 "d3d25e65af572af49e2c75d4096eba6ca3b97ce2b75f06977e2b6d189e2451c8"
      type :backport
      resolves "https://github.com/ansible/ansible/issues/87677"
    end
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
    url "https://files.pythonhosted.org/packages/4d/fc/137095eb2f24ccf0b4db196abd9f5cfe74398a834af51d4bc4876e0beaf0/bracex-3.2.1.tar.gz"
    sha256 "07a9b2100ceecc0c24afa1a1714bf8d4a6abb43d592939455f662b682ac9baa4"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/a3/1d/d730c664fcb4f1d264a722722a3134cf0881854f73c1fd58abf87572f232/filelock-4.2.9.tar.gz"
    sha256 "96530b7c538d4ea08493ab067247aab7948c54d8cd622cce711c97cccc5d9896"
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
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/9a/8475be631fb33ca1466915e70fd594c42a4e84b512db650eaa14f90fe75d/platformdirs-4.14.5.tar.gz"
    sha256 "32e9921db7385aa8169bee4fe9501923e5715ba9fb7ea3b9c69b0d8e0639f7a1"
  end

  resource "pytokens" do
    url "https://files.pythonhosted.org/packages/b6/34/b4e015b99031667a7b960f888889c5bd34ef585c85e1cb56a594b92836ac/pytokens-0.4.1.tar.gz"
    sha256 "292052fe80923aae2260c073f822ceba21f3872ced9a68bb7953b348e561179a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
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
    url "https://files.pythonhosted.org/packages/60/81/eb96ce41e8def4ff3b02cec7d1d92e3682597de5064d8687ac88d1734f18/wcmatch-12.0.tar.gz"
    sha256 "80ebfdf510d5fef580c4fc662b9eba76b331cff20d7913fc6e722edcb199cbe6"
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
