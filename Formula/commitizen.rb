class Commitizen < Formula
  include Language::Python::Virtualenv

  desc "Defines a standard way of committing rules and communicating it"
  homepage "https://commitizen-tools.github.io/commitizen/"
  url "https://files.pythonhosted.org/packages/f0/bc/673ed0b345882511dde1bc43e8f2b95e0b5ff74fa11dc3e1461ef5dba9d5/commitizen-2.14.1.tar.gz"
  sha256 "4202804e098a84443c3c0c0955a92e617110d263e37e6800f9916cf6af20fa20"
  license "MIT"
  head "https://github.com/commitizen-tools/commitizen.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8dab29f65bb585bc5f392fdf8b553908eccf49936400e3aefbcd5b7cfff2da1f"
    sha256 cellar: :any_skip_relocation, big_sur:       "08e027f622f2569be91d555c6279910438cef56c85e13f0aed413a8237a3886b"
    sha256 cellar: :any_skip_relocation, catalina:      "edda4007c88b9a789feba786525bc624cda2b9efab3b09f8644f9fcf8d440d86"
    sha256 cellar: :any_skip_relocation, mojave:        "1e3972cadd40df90ec773d317e2faff3e7f1c09defd1c744d1fd9e4cf6dce26a"
  end

  depends_on "python@3.9"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/cb/53/d2e3d11726367351b00c8f078a96dacb7f57aef2aca0d3b6c437afc56b55/argcomplete-1.12.2.tar.gz"
    sha256 "de0e1282330940d52ea92a80fea2e4b9e0da1932aaa570f84d268939d1897b04"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "decli" do
    url "https://files.pythonhosted.org/packages/9f/30/064f53ca7b75c33a892dcc4230f78a1e01bee4b5b9b49c0be1a61601c9bd/decli-0.5.2.tar.gz"
    sha256 "f2cde55034a75c819c630c7655a844c612f2598c42c21299160465df6ad463ad"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/b1/46/4eb242362c43cf033b4ec4d7205612c46c9f904a8984cdfdb64d35476175/prompt_toolkit-3.0.14.tar.gz"
    sha256 "7e966747c18ececaec785699626b771c1ba8344c8d31759a1915d6b12fad6525"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/b5/a5/20e0d643ce997cd5d87b3100373e24eb2c6aa874f713b08552a01639145e/questionary-1.9.0.tar.gz"
    sha256 "a050fdbb81406cddca679a6f492c6272da90cb09988963817828f697cf091c55"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/64/e0/6c8c96024d118cb029a97752e9a6d70bd06e4fd4c8b00fd9446ad6178f1d/tomlkit-0.7.0.tar.gz"
    sha256 "ac57f29693fab3e309ea789252fcce3061e19110085aa31af5446ca749325618"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Generates a changelog after an example commit
    system "git", "init"
    touch "example"
    system "git", "add", "example"
    system "yes | #{bin}/cz commit"
    system "#{bin}/cz", "changelog"

    # Verifies the checksum of the changelog
    expected_sha = "97da642d3cb254dbfea23a9405fb2b214f7788c8ef0c987bc0cde83cca46f075"
    output = File.read(testpath/"CHANGELOG.md")
    assert_match Digest::SHA256.hexdigest(output), expected_sha
  end
end
