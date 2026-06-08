class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://ansible-lint.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/e4/39/54f7cc264f7f02c635af786c4a57da4ab993865140f90e031cdec39dd514/ansible_lint-26.4.0.tar.gz"
  sha256 "29e0438f8af685a4fec96f9ea3404a3beb50d2911bc8df43f283256954ceea5b"
  license all_of: ["MIT", "GPL-3.0-or-later"]
  revision 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "935581006209f393d496770ce522493b65d5519fda6bc45315c13dad64c49b56"
    sha256 cellar: :any, arm64_sequoia: "7250b1557e336194d48dca4b42be5bd043fb19b1d244532de0ded3ddf7d1f0ee"
    sha256 cellar: :any, arm64_sonoma:  "e87539aee22c5c4a15280e37925b717eea754fd50a195edf9224e321a11e0ed3"
    sha256 cellar: :any, sonoma:        "92e1e5a5d00aea6baa98db6d44ef6adf195d53bdd6ffaaaef94419f011166261"
    sha256 cellar: :any, arm64_linux:   "db6159ea70f0e7be3f41de5f45dd12b642f7d8cf9309b0ec42ea1b50f170049d"
    sha256 cellar: :any, x86_64_linux:  "341ea598de3539a27db16fa2e4f001ef37c52f6bf922397ac267ee147fd356e7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ansible" => :test
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: ["cryptography", "rpds-py"]

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/04/42/53ba59f8116e716ec0af8dc47ef65b15f5e3bc28131e8e6cbe87e50203f5/ansible_compat-26.3.0.tar.gz"
    sha256 "15f0ea5ff6fcc5587b6b11a4a436fdeefd0fd4a46afe92d4e483c28370082ae0"
  end

  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/a3/f6/8da4912a93e1319292bada5e5185e82b1a12cf212da7a7cc4589064f3247/ansible_core-2.21.0.tar.gz"
    sha256 "28ccd0e2d1849f1c7272cec39a74a8a5c83f3d51314658fa5ca57ea85a87f454"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/c0/37/5628dd55bf2b34257fc7603f0fe97c40e3aaf24265f416a9c85c95ca1436/black-26.5.1.tar.gz"
    sha256 "dd321f668053961824bcc1be1cc1df748b2d7e4fa28086b08331e577b0100a73"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/63/9a/fec38644694abfaaeca2798b58e276a8e61de49e2e37494ace423395febc/bracex-2.6.tar.gz"
    sha256 "98f1347cd77e22ee8d967a30ad4e310b233f7754dbf31ff3fceb76145ba47dc7"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/b5/fe/997687a931ab51049acce6fa1f23e8f01216374ea81374ddee763c493db5/filelock-3.29.0.tar.gz"
    sha256 "69974355e960702e789734cb4871f884ea6fe50bd8404051a3530bc07809cf90"
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
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/fa/36/e27608899f9b8d4dff0617b2d9ab17ca5608956ca44461ac14ac48b44015/pathspec-1.0.4.tar.gz"
    sha256 "0210e2ae8a21a9137c0d470578cb0e595af87edaa6ebf12ff176f14a02e0e645"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
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
    url "https://files.pythonhosted.org/packages/79/3e/c0bdc27cf06f4e47680bd5803a07cb3dfd17de84cde92dd217dcb9e05253/wcmatch-10.1.tar.gz"
    sha256 "f11f94208c8c8484a16f4f48638a85d771d9513f4ab3f37595978801cb9465af"
  end

  resource "yamllint" do
    url "https://files.pythonhosted.org/packages/28/a0/8fc2d68e132cf918f18273fdc8a1b8432b60d75ac12fdae4b0ef5c9d2e8d/yamllint-1.38.0.tar.gz"
    sha256 "09e5f29531daab93366bb061e76019d5e91691ef0a40328f04c927387d1d364d"
  end

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
    ansible = Formula["ansible"].opt_bin/"ansible"
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
