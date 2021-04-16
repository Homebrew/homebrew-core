class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://github.com/ansible/ansible-lint/"
  url "https://files.pythonhosted.org/packages/d2/46/a8065d3a89e5136430fc63922455ceafe712d6c05cfe2ee635a8d93f3d47/ansible-lint-5.0.7.tar.gz"
  sha256 "d63b72df37000c72378cb1ae0f48a5ba6410ce650717d81d818e528208eecf91"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "20238822ae304c5c3f2969ece4bf91426e3fbd9415cd8ff621d5be2cf9b13a36"
    sha256 cellar: :any, big_sur:       "abc31e23851db5273b5d72acc22b1beb22fd903be02e14380ab4128c64de3175"
    sha256 cellar: :any, catalina:      "ecc5b6c656c1640ef93055e4161e43c4f1beeb21da2ab0ebff2481efe31fec1e"
    sha256 cellar: :any, mojave:        "c1b983e0c06c48a3db7addd2e2ea0381d186f1b456b51e3897c2f7fa64256738"
  end

  depends_on "pkg-config" => :build
  depends_on "ansible"
  depends_on "libyaml"
  depends_on "python@3.9"

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/bb/80/7118945282845f8dc337c45c7d9d171a9f86d0c7650ac7e65d60995691d2/bracex-2.1.1.tar.gz"
    sha256 "01f715cd0ed7a622ec8b32322e715813f7574de531f09b70f6f3b2c10f682425"
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
    url "https://files.pythonhosted.org/packages/47/2b/b453d52a5cd1409d859d67c6a530971095406aedc0c0589c1c6a5212f506/enrich-1.2.6.tar.gz"
    sha256 "0e99ff57d87f7b5def0ca79917e88fb9351aa0d52e228ee38bff7cd858315fe4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/15/9d/bc9047ca1eee944cc245f3649feea6eecde3f38011ee9b8a6a64fb7088cd/Pygments-2.8.1.tar.gz"
    sha256 "2656e1a6edcdabf4275f9a3640db59fd5de107d88e8663c5d4e9a0fa62f77f94"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/12/3c/e4e2b356057f3ce557fcda8a2b9bf114b06f71ade88dac8a0883ae800e28/rich-10.1.0.tar.gz"
    sha256 "8f05431091601888c50341697cfc421dc398ce37b12bca0237388ef9c7e2c9e9"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/88/4d/ec3d9d9eca7903c9746976a0157b352c1b1dcb8d9de4590a95f671d44790/ruamel.yaml-0.17.2.tar.gz"
    sha256 "8f1e15421668b9edf30ed02899f5f81aff9808a4271935776f61a99a569a13da"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/fa/a1/f9c009a633fce3609e314294c7963abe64934d972abea257dce16a15666f/ruamel.yaml.clib-0.2.2.tar.gz"
    sha256 "2d24bd98af676f4990c4d715bcdc2a60b19c56a3fb3a763164d2d8ca0e806ba7"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/9e/ff/65d44f70e9a5273b6185ccbff194bb649e4fa6bd328113feda964f277f2d/tenacity-7.0.0.tar.gz"
    sha256 "5bd16ef5d3b985647fe28dfa6f695d343aa26479a04e8792b9d3c8f49e361ae1"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/06/0f7367eafb692f73158e5c5cbca1aec798cdf78be5167f6415dd4205fa32/typing_extensions-3.7.4.3.tar.gz"
    sha256 "99d4073b617d30288f569d3f13d2bd7548c3a7e4c8de87db09a9d29bb3a4a60c"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/24/b9/51525e9aea08d04e602a53812afe3890e78d204e55464f8d0ea906587e54/wcmatch-8.1.2.tar.gz"
    sha256 "efda751de15201b395b6d6e64e6ae3b6b03dc502a64c3c908aa5cad14c27eee5"
  end

  def install
    virtualenv_install_with_resources
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
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
