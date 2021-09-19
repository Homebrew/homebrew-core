class Commitizen < Formula
  include Language::Python::Virtualenv

  desc "Defines a standard way of committing rules and communicating it"
  homepage "https://commitizen-tools.github.io/commitizen/"
  url "https://files.pythonhosted.org/packages/19/66/8ce356d2cddaf83b201d6115b3bd9c596de9489d1cc19947254e3d4ae836/commitizen-2.18.1.tar.gz"
  sha256 "76b83d2e0f00e5aeef823dd8d4b289c92da980cb4233065f4a8c59bf3078ef18"
  license "MIT"
  head "https://github.com/commitizen-tools/commitizen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "960a238fc1682740c05dd6d2a52a641b45330416a2d164bccb48bf3ecb2556e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "f9ebb66ac412337437202968b41365cda02919de37c91eca4f4ac1c6a897af49"
    sha256 cellar: :any_skip_relocation, catalina:      "2f27475d2fe3e52eb1309d5a3ba063703388cd78d882f05b00bd98e3b8b1696d"
    sha256 cellar: :any_skip_relocation, mojave:        "d778282d6d084818d12c7245e875549f9fbb66ee0fc08a548f6b406e621d892f"
  end

  depends_on "python@3.9"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
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
    url "https://files.pythonhosted.org/packages/39/11/8076571afd97303dfeb6e466f27187ca4970918d4b36d5326725514d3ed3/Jinja2-3.0.1.tar.gz"
    sha256 "703f484b47a6af502e743c9122595cc812b0271f661722403114f71a79d0f5a4"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/b4/56/9ab5868f34ab2657fba7e2192f41316252ab04edbbeb2a8583759960a1a7/prompt_toolkit-3.0.20.tar.gz"
    sha256 "eb71d5a6b72ce6db177af4a7d4d7085b99756bf656d98ffcc4fecd36850eea6c"
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
    url "https://files.pythonhosted.org/packages/04/c6/a8dbf1edcbc236d93348f6e7c437cf09c7356dd27119fcc3be9d70c93bb1/questionary-1.10.0.tar.gz"
    sha256 "600d3aefecce26d48d97eee936fdb66e4bc27f934c3ab6dd1e292c4f43946d90"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/65/ed/7b7216101bc48627b630693b03392f33827901b81d4e1360a76515e3abc4/tomlkit-0.7.2.tar.gz"
    sha256 "d7a454f319a7e9bd2e249f239168729327e4dd2d27b17dc68be264ad1ce36754"
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
