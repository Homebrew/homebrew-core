class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://github.com/ansible/ansible-lint/"
  url "https://files.pythonhosted.org/packages/f5/e9/b359bd8b6581734f958a2704d1e8201647fdc99b5ae87fabf97874d91a34/ansible-lint-5.0.12.tar.gz"
  sha256 "f2b0b74bd05cf55f0bb45304767e1862ed62c05def06e1f03aa2c2d39c67907c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "eb2f3f12f690a2d2802d1630ccdfe91d2668bf2314dab94f391446379b944e23"
    sha256 cellar: :any, big_sur:       "a99957276ff6a81d7af43a762195d6539754c0db8e22fd0d7eb319659d098e50"
    sha256 cellar: :any, catalina:      "531c1e77c4f68ceb1f123d23535100241fdc3021c85f51ae61ac280c804eefea"
    sha256 cellar: :any, mojave:        "a019409cfeeefab8830a3d64027e9f9add8f96b0d465a9d5443430fc674b1efe"
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
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
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
    url "https://files.pythonhosted.org/packages/1e/cc/ced09195051b5384e9a82d6de7fc1a3917017fe214d30d41a9935cea465d/rich-10.2.2.tar.gz"
    sha256 "17b3f486c38e79cc219d8848974b277ef532a82d12b3ad6eb37bb8c6f22ab5fc"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/fd/6b/b83bdc8fb9aad62f6469117874e7c11b64d94ba9e8557f73ca1f28c2df7d/ruamel.yaml-0.17.7.tar.gz"
    sha256 "5c3fa739bbedd2f23769656784e671c6335d17a5bf163c3c3901d8663c0af287"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/fa/a1/f9c009a633fce3609e314294c7963abe64934d972abea257dce16a15666f/ruamel.yaml.clib-0.2.2.tar.gz"
    sha256 "2d24bd98af676f4990c4d715bcdc2a60b19c56a3fb3a763164d2d8ca0e806ba7"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/9e/ff/65d44f70e9a5273b6185ccbff194bb649e4fa6bd328113feda964f277f2d/tenacity-7.0.0.tar.gz"
    sha256 "5bd16ef5d3b985647fe28dfa6f695d343aa26479a04e8792b9d3c8f49e361ae1"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/47/63/88168196fdcd77e012944bb83ab589a9d53336b8094703a64567f0bf218c/wcmatch-8.2.tar.gz"
    sha256 "4d54ddb506c90b5a5bba3a96a1cfb0bb07127909e19046a71d689ddfb18c3617"
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
