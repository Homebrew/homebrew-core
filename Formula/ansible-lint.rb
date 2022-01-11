class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://github.com/ansible/ansible-lint/"
  url "https://files.pythonhosted.org/packages/fa/8f/73f43b56d270dbebe36760c49132acbc18a824121b249a5810d2b13a385c/ansible-lint-5.3.2.tar.gz"
  sha256 "9ba886db4c44e59360bc8d668f0beae6193c0a1fcbb9e76127000ca3aced7c28"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c68375f8a4a1d9a64f11bc3701b335968317dca58923294395d733686057c0fe"
    sha256 cellar: :any,                 arm64_big_sur:  "9bcc5617df8382e30887927774f1898c4b837d4d5e6502a1aea8d3992059250d"
    sha256 cellar: :any,                 monterey:       "9cf38cecb4f456896ca8f35dae3f4150188998f03b5159a0daf3d26494e8a716"
    sha256 cellar: :any,                 big_sur:        "3cb2aa07907a84b6fc649b12d4fffe4ecc62e29ac3c2131d1e8acabacfd714d2"
    sha256 cellar: :any,                 catalina:       "8d481cb5ae545ae59271916b0df92d98651371b42d1db69ee5ac2da2b9c24a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e31657d5a43aa63d0875eb644106c0c602e0b2232681c68d5703f3b77f397e56"
  end

  depends_on "pkg-config" => :build
  depends_on "ansible"
  depends_on "libyaml"
  depends_on "python@3.10"

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/bd/ef/6273bba9e5bc615aab4997159eeaddfe03c825eeabe2942c39e91be5afec/bracex-2.2.1.tar.gz"
    sha256 "1c8d1296e00ad9a91030ccb4c291f9e4dc7c054f12c707ba3c5ff3e9a81bcd21"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "enrich" do
    url "https://files.pythonhosted.org/packages/bb/77/cb9b3d6f2e2e5f8104e907ea4c4d575267238f52c51cf9f864b865a99710/enrich-1.2.7.tar.gz"
    sha256 "0a2ab0d2931dff8947012602d1234d2a3ee002d9a355b5d70be6bf5466008893"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/eb/be/bd5d6c37f5de55f31cb9432e0d926ceeab1b2ee774bd696557b53bc15012/rich-11.0.0.tar.gz"
    sha256 "c32a8340b21c75931f157466fefe81ae10b92c36a5ea34524dff3767238774a4"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/2d/b1/b672cbe8be9ea09d85d2be8c3693811362295aa8483849e85b41caaadb85/ruamel.yaml-0.17.20.tar.gz"
    sha256 "4b8a33c1efb2b443a93fcaafcfa4d2e445f8e8c29c528d9f5cdafb7cc9e4004c"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/8b/25/08e5ad2431a028d0723ca5540b3af6a32f58f25e83c6dda4d0fcef7288a3/ruamel.yaml.clib-0.2.6.tar.gz"
    sha256 "4ff604ce439abb20794f05613c374759ce10e3595d1867764dd1ae675b85acbd"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/2c/f5/04748914f5c78f7418b803226bd56cdddd70ac369b936b3e24f5158017f1/tenacity-8.0.1.tar.gz"
    sha256 "43242a20e3e73291a28bcbcacfd6e000b02d3857a9a9fff56b297a27afdc932f"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/a7/73/7c739ae235b7e3ee36f2c0084a595b89c62aefeafa52df8d54d26846b32b/wcmatch-8.3.tar.gz"
    sha256 "371072912398af61d1e4e78609e18801c6faecd3cb36c54c82556a60abc965db"
  end

  def install
    virtualenv_install_with_resources
    xy = Language::Python.major_minor_version Formula["python@3.10"].opt_bin/"python3"
    site_packages = "lib/python#{xy}/site-packages"
    ansible = Formula["ansible"].opt_libexec
    (libexec/site_packages/"homebrew-ansible.pth").write ansible/site_packages
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~EOS
      ---
      - hosts: all
        gather_facts: False
        tasks:
        - name: ping
          ping:
    EOS
    system bin/"ansible-lint", testpath/"playbook.yml"
  end
end
