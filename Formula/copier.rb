class Copier < Formula
  include Language::Python::Virtualenv

  desc "Utility for rendering projects templates"
  homepage "https://copier.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/f7/f5/a8a9a43efaf030c25b579ddcdab7bf051a6df8b5d3f801111dc02cd48d8a/copier-6.2.0.tar.gz"
  sha256 "792c66ed1a6eddd85690ba12035fdbf087a65b18c8b07c2527e3581296e29649"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5335a554f678a280af7bd40fccb5f6f39ed0a7c9464f40971690913fe463949b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a0928b3e7dfc213378aeb2ab135b7c3cef5546c31f6f2f8ed6e2c834ea7e52e"
    sha256 cellar: :any_skip_relocation, monterey:       "1443d06b6ee97cc4d6312625e20dba6e1f03ec16dce14c9a9b536e390e4fb4fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "10a1c61016a63749686645deb614488ecace51d3ca73655106e35b98d5e8e04a"
    sha256 cellar: :any_skip_relocation, catalina:       "a77ef63c4cab9f47dd49814bbeba730647bb814eb4c7100361e9bb22b73878d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7d423c505e0c89b9ffb63c34725644ccf99199d9837edfddeb20702dc7fabbc"
  end

  depends_on "python@3.10"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "dunamai" do
    url "https://files.pythonhosted.org/packages/2d/e4/d92c4e1ac3115575c9a8d528625adf08ad3a980f8236a34486e49a7ad381/dunamai-1.13.0.tar.gz"
    sha256 "5bf9e5baaa673b692a9613e4961b18b6d2d9743412f7bbcf4a39c84a979f47e2"
  end

  resource "iteration-utilities" do
    url "https://files.pythonhosted.org/packages/0d/27/88eed2efe269faa330f702c02a7b8c98076db9551a8c2e931348b0f78077/iteration_utilities-0.11.0.tar.gz"
    sha256 "f91f41a2549e9a7e40ff5460fdf9033b6ee5b305d9be77943b63a554534c2a77"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jinja2-ansible-filters" do
    url "https://files.pythonhosted.org/packages/1a/27/fa186af4b246eb869ffca8ffa42d92b05abaec08c99329e74d88b2c46ec7/jinja2-ansible-filters-1.3.2.tar.gz"
    sha256 "07c10cf44d7073f4f01102ca12d9a2dc31b41d47e4c61ed92ef6a6d2669b356b"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/24/9f/a9ae1e6efa11992dba2c4727d94602bd2f6ee5f0dedc29ee2d5d572c20f7/pathspec-0.10.1.tar.gz"
    sha256 "7ace6161b621d31e7902eb6b5ae148d12cfd23f4a249b9ffb6b9fee12084323d"
  end

  resource "plumbum" do
    url "https://files.pythonhosted.org/packages/c8/d8/aa3973de6151ae322e3f0dd4f2befcece695ed7c09d49536d8174ef80a9c/plumbum-1.7.2.tar.gz"
    sha256 "0d1bf908076bbd0484d16412479cb97d6843069ee19f99e267e11dd980040523"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/80/76/c94cf323ca362dd7baca8d8ddf3b5fe1576848bc0156522ad581c04f8446/prompt_toolkit-3.0.31.tar.gz"
    sha256 "9ada952c9d1787f52ff6d5f3484d0b4df8952787c087edf6a1f7c2cb1ea88148"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/7d/7d/58dd62f792b002fa28cce4e83cb90f4359809e6d12db86eedf26a752895c/pydantic-1.10.2.tar.gz"
    sha256 "91b8e218852ef6007c2b98cd861601c6a09f1aa32bbbb74fab5b1c33d4a1e410"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "pyyaml-include" do
    url "https://files.pythonhosted.org/packages/84/df/c57e47c8d144a424b57304f58661bd09d5bece6c43ac79f3bd4b727f5445/pyyaml-include-1.3.tar.gz"
    sha256 "f7fbeb8e71b50be0e6e07472f7c79dbfb1a15bade9c93a078369ff49e57e6771"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/04/c6/a8dbf1edcbc236d93348f6e7c437cf09c7356dd27119fcc3be9d70c93bb1/questionary-1.10.0.tar.gz"
    sha256 "600d3aefecce26d48d97eee936fdb66e4bc27f934c3ab6dd1e292c4f43946d90"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/9e/1d/d128169ff58c501059330f1ad96ed62b79114a2eb30b8238af63a2e27f70/typing_extensions-4.3.0.tar.gz"
    sha256 "e6d2677a32f47fc7eb2795db1dd15c1f34eff616bcaf2cfb5e997f854fa1c4a6"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    params = %w[
      -d python=true
      -d js=true
      -d ansible=false
      -d biggest_kbs=1000
      -d main_branches=null
      -d github=true
    ]
    system bin/"copier", *params, "--vcs-ref=v0.1.0", "https://github.com/copier-org/autopretty.git", "template"
    assert (testpath/"template").directory?
    assert_predicate testpath/"template/.copier-answers.autopretty.yml", :exist?
  end
end
