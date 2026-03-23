class Dotdrop < Formula
  include Language::Python::Virtualenv

  desc "Save your dotfiles once, deploy them everywhere"
  homepage "https://github.com/deadc0de6/dotdrop"
  # TODO: check if source is available on pypi distribution: https://pypi.org/project/dotdrop/#files
  url "https://github.com/deadc0de6/dotdrop/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "2b2f87214e3f12ea83a7b297558e55c628bc3a1d86a8e63bd16a9793a45fb418"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac901832beaf8ba175a02be8f2fa2ffd93c14aedd541d52101de7e0f9e45ffba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afbda11e747314b1a5b98786eef541cb17fbaaf7bc482c0627e6060424ed5821"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "358e76c171bebcc6fd334b2760e0d8a0d276fb20607861473cda9c4614b72058"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d90326490174a15810f18800889fae3089ba54d1819e61e7279b8186b7dac7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65aecf9795063edbccb934995d7f2af652634ac089615264e9ed095f4df47c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "554374cfabfa54201ac62ad014088ef6461b3d584d4de2f39aecaad518521c9b"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libmagic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "docopt-ng" do
    url "https://files.pythonhosted.org/packages/e4/50/8d6806cf13138127692ae6ff79ddeb4e25eb3b0bcc3c1bd033e7e04531a9/docopt_ng-0.9.0.tar.gz"
    sha256 "91c6da10b5bb6f2e9e25345829fb8278c78af019f6fc40887ad49b060483b1d7"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"xxx.conf").write("12345678")
    (testpath/"config.yaml").write <<~YAML
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
    YAML
    system bin/"dotdrop", "install", "--profile=home"
    assert_match "12345678", File.read("yyy.conf")
  end
end
