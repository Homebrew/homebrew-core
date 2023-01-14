class Dotdrop < Formula
  include Language::Python::Virtualenv

  desc "Save your dotfiles once, deploy them everywhere"
  homepage "https://deadc0de.re/dotdrop"
  url "https://files.pythonhosted.org/packages/a7/ed/6c24d9ab04e483b16dacf0fc4e7de26b90b9f46801537a69db4c62674aab/dotdrop-1.12.4.tar.gz"
  sha256 "1630cd14aa3495b3de4eb3c1dbdc8f9566cfe52a1dbaaff127167215b798a0ba"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "780e0199b4300b848560a99469d800f45ffc6dd8fa008af9671f3f358de2b7b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e37996a43c1a1b19445d8393b237e6af50e3eefd37a03b60b6fc73478e5638b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9874a544c44f133efc119643f6b6343974d11ee4911818a9c7f1fad33813e562"
    sha256 cellar: :any_skip_relocation, ventura:        "f58a1bb8a162063c961f34534277069d4ce0c22ee6af9808f6675116fd803e0b"
    sha256 cellar: :any_skip_relocation, monterey:       "4cae2e7a186047b057a5b83988919c8ef97c46f07a6baeae3bf11e088843fff2"
    sha256 cellar: :any_skip_relocation, big_sur:        "705aa458865c518fba67d427e0daee5cd907d410e0877026200e83cb1b95eec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e42bf6adad847e8e4d336d8813375bfd301dd16997c7a4cfff3250542980f663"
  end

  depends_on "libmagic"
  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"xxx.conf").write("12345678")
    (testpath/"config.yaml").write <<~EOS
      config:
        dotpath: .
      dotfiles:
        f_xxx:
          dst: yyy.conf
          src: xxx.conf
      profiles:
        home:
          dotfiles:
          - f_xxx
    EOS
    system bin/"dotdrop", "install", "--profile=home"
    assert_match "12345678", File.read("yyy.conf")
  end
end
