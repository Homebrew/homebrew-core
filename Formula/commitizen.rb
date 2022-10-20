class Commitizen < Formula
  include Language::Python::Virtualenv

  desc "Defines a standard way of committing rules and communicating it"
  homepage "https://commitizen-tools.github.io/commitizen/"
  url "https://files.pythonhosted.org/packages/a2/b0/ae4a211b1aaa8ad5b77911d353900dc4eba79a2569beb3cb178ce6e47a3f/commitizen-2.35.0.tar.gz"
  sha256 "34a7462c2279fc4e22929c03a9bb89242ab45dc501c0f17d1174e65c7fb9d793"
  license "MIT"
  head "https://github.com/commitizen-tools/commitizen.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d821ea5723b623cab0edc5ca3fc393f95d5eec6d125f5a41514c1ddeb320fa97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71168bb40062add4baf04de8b1d5cc3b9fb7fb07d075909ef916d5b144586b93"
    sha256 cellar: :any_skip_relocation, monterey:       "af6023e3344bba8b5db72c003d018ea555e84a6c06ef77fad203a89afcd47692"
    sha256 cellar: :any_skip_relocation, big_sur:        "de36cefbdeb7a23cfc10d3b6c40e3fd38ef652fd963ee1a7bcc4314aae79cbad"
    sha256 cellar: :any_skip_relocation, catalina:       "a98de529f5fdd2058307f28e56f1821f067846a16d3c4190c1a018659675a712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4134f5e399aacbf862ad1d9ce8322dd8134bb0180bc9842d8e4baa7c1b20ef64"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.10"
  depends_on "pyyaml"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "decli" do
    url "https://files.pythonhosted.org/packages/9f/30/064f53ca7b75c33a892dcc4230f78a1e01bee4b5b9b49c0be1a61601c9bd/decli-0.5.2.tar.gz"
    sha256 "f2cde55034a75c819c630c7655a844c612f2598c42c21299160465df6ad463ad"
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
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/80/76/c94cf323ca362dd7baca8d8ddf3b5fe1576848bc0156522ad581c04f8446/prompt_toolkit-3.0.31.tar.gz"
    sha256 "9ada952c9d1787f52ff6d5f3484d0b4df8952787c087edf6a1f7c2cb1ea88148"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/04/c6/a8dbf1edcbc236d93348f6e7c437cf09c7356dd27119fcc3be9d70c93bb1/questionary-1.10.0.tar.gz"
    sha256 "600d3aefecce26d48d97eee936fdb66e4bc27f934c3ab6dd1e292c4f43946d90"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/c1/ee/ad1f448e360e4b662fbff9e75cd210b73ad79998ce6483086e9df5b8e7e2/termcolor-2.0.1.tar.gz"
    sha256 "6b2cf769e93364a2676e1de56a7c0cff2cf5bd07f37e9cc80b0dd6320ebfe388"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/84/51/092a8b945edc3b93f2de091ab9596006673caac063e3fac14f0fa6c69b1c/tomlkit-0.11.4.tar.gz"
    sha256 "3235a9010fae54323e727c3ac06fb720752fe6635b3426e379daec60fbd44a83"
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
