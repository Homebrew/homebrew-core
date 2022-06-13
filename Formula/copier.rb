class Copier < Formula
  include Language::Python::Virtualenv

  desc "Utility for rendering projects templates"
  homepage "https://copier.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/d4/1a/a518411edbe28df377b2f4aca4be61b86b52f625592c3c5bfd68f25f4131/copier-6.1.0.tar.gz"
  sha256 "d3b399285763e97a1c3c49cbc7e0d3b3cea2f05b680f652ff58d59a5b59f3a3c"
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
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "dunamai" do
    url "https://files.pythonhosted.org/packages/e6/4b/57276a5edd2ddbd89f00d08ee78419f6c6432a3090125cb41d472d5155c8/dunamai-1.12.0.tar.gz"
    sha256 "fac4f09e2b8a105bd01f8c50450fea5aa489a6c439c949950a65f0dd388b0d20"
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
    url "https://files.pythonhosted.org/packages/bc/30/2a0e94ff558bea376f48beedfcdaaa2de46fee6c4ae0fd18db94f066f3fe/jinja2-ansible-filters-1.3.1.tar.gz"
    sha256 "baa04873c2d31a82df67f5a313988630fb713c625d858226314d283f0b12879a"
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
    url "https://files.pythonhosted.org/packages/f6/33/436c5cb94e9f8902e59d1d544eb298b83c84b9ec37b5b769c5a0ad6edb19/pathspec-0.9.0.tar.gz"
    sha256 "e564499435a2673d586f6b2130bb5b95f04a3ba06f81b8f895b651a3c76aabb1"
  end

  resource "plumbum" do
    url "https://files.pythonhosted.org/packages/c8/d8/aa3973de6151ae322e3f0dd4f2befcece695ed7c09d49536d8174ef80a9c/plumbum-1.7.2.tar.gz"
    sha256 "0d1bf908076bbd0484d16412479cb97d6843069ee19f99e267e11dd980040523"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/59/68/4d80f22e889ea34f20483ae3d4ca3f8d15f15264bcfb75e52b90fb5aefa5/prompt_toolkit-3.0.29.tar.gz"
    sha256 "bd640f60e8cecd74f0dc249713d433ace2ddc62b65ee07f96d358e0b152b6ea7"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/d0/a5/e4a25a0becf35530a3d90459a88855743e942f2e502da49ca5b10aa78568/pydantic-1.9.1.tar.gz"
    sha256 "1ed987c3ff29fff7fd8c3ea3a3ea877ad310aae2ef9889a119e22d3f2db0691a"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
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
    url "https://files.pythonhosted.org/packages/fe/71/1df93bd59163c8084d812d166c907639646e8aac72886d563851b966bf18/typing_extensions-4.2.0.tar.gz"
    sha256 "f1c24655a0da0d1b67f07e17a5e6b2a105894e6824b92096378bb3668ef02376"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    # Handle missing `VERSION` file
    resource("jinja2-ansible-filters").stage do |r|
      inreplace "setup.cfg", "version = file: VERSION", "version = #{r.version}"
      venv.pip_install Pathname.pwd
    end

    venv.pip_install resources.reject { |r| r.name == "jinja2-ansible-filters" }
    venv.pip_install_and_link buildpath
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
