class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package manager with PEP 582 support"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/70/a4/8df14f24170480bd56930234e4956bb08c55684e9dcac8f4b7c1a5ac4423/pdm-1.7.2.tar.gz"
  sha256 "35d7cb106106a445098100b4ad3ef0810af71eaa3a2ea9b0127b60e295738e08"
  license "MIT"
  head "https://github.com/pdm-project/pdm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4c98baf05c3efe70eefea2f3899afa9afd7e4613f1bc38b00bf0d06125991049"
    sha256 cellar: :any_skip_relocation, big_sur:       "e3097c4f1c0172bbb5906435f2b6acc748bc5c3315ba19dd5867d29f0b48399b"
    sha256 cellar: :any_skip_relocation, catalina:      "96e7390b772d4dca10255be031b1ed5d9409237627935c37c1b8cc57aee89666"
    sha256 cellar: :any_skip_relocation, mojave:        "cd429f7a2e8ddd7dc73e04e4a1a2c182407a764bc7e3b341b73313d441d8c4f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d633ee433fa48c97dcbdd56ff46032bdc411622000d32cf310408ed6869ee2ac"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "atoml" do
    url "https://files.pythonhosted.org/packages/e8/23/a7d7d9615d15e20bf3219b6dbf023112fc172b35462c949142037b53d8d7/atoml-1.0.3.tar.gz"
    sha256 "5dd70efcafde94a6aa5db2e8c6af5d832bf95b38f47d3283ee3779e920218e94"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/59/23/e4a9d51192dbbcb7b17a4297e4d3c48f67771dfa98f66535a019f9f21273/installer-0.2.3.tar.gz"
    sha256 "82c899f5e3c78303242df9c9ca7ac58001c9806d8c23fa2772be769d1f560fe5"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/86/aef78bab3afd461faecf9955a6501c4999933a48394e90f03cd512aad844/packaging-21.0.tar.gz"
    sha256 "7dc96269f53a4ccec5c0670940a4281106dd0bb343f47b7471f779df49c2fbe7"
  end

  resource "pdm-pep517" do
    url "https://files.pythonhosted.org/packages/98/de/40b17fc026f4a484e6020fd6ef1246b9f78522abdffd12b13e94f25779ae/pdm-pep517-0.8.0.tar.gz"
    sha256 "f1fcde8abe39df39ec58077ebab4bd26f0c2bfce023c8aec0d8762abf71ff7c5"
  end

  resource "pep517" do
    url "https://files.pythonhosted.org/packages/da/12/6d373f746ad1cec5ab9415d6a1df54ecc0a9001124bd771742755dcecded/pep517-0.11.0.tar.gz"
    sha256 "e1ba5dffa3a131387979a68ff3e391ac7d645be409216b961bc2efe6468ab0b2"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/59/39/20eb771fc2113fb67638d4f2e1905c51b0c75862d09018a393470234a51c/python-dotenv-0.19.0.tar.gz"
    sha256 "f521bc2ac9a8e03c736f62911605c5d83970021e3fa95b37d769e2bbbe9b6172"
  end

  resource "pythonfinder" do
    url "https://files.pythonhosted.org/packages/9a/2e/3dfcf82713bddfb79a36c7c183bcb03f965b3b14b7f5e832483ec22b5c71/pythonfinder-1.2.8.tar.gz"
    sha256 "e3ea90d327f2ff61a692af9326deced042bb27f6fd562fc788637abee9bd62d9"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/0f/79/248bf2687fdaa4a3d8f695a51f03dac38f4c902de7a48b10ccc374bd6b5c/resolvelib-0.7.1.tar.gz"
    sha256 "c526cda7f080d908846262d86c738231d9bfb556eb02d77167b685d65d85ace9"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/9c/c9/a3e3bc667c8372a74aa4b16649c3466364cd84f7aacb73453c51b0c2c8a7/shellingham-1.4.0.tar.gz"
    sha256 "4855c2458d6904829bd34c299f11fdeed7cfefbf8a2c522e4caea6cd76b3171e"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/ec/38/8eccdc662c61aed187d5f5b168c18b1d2de3827976c3691e4da8be7375aa/tomli-1.2.0.tar.gz"
    sha256 "d60e681734099207a6add7a10326bc2ddd1fdc36c1b0f547d00ef73ac63739c2"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/ed/46/e298a50dde405e1c202e316fa6a3015ff9288423661d7ea5e8f22f589071/wheel-0.36.2.tar.gz"
    sha256 "e11eefd162658ea59a60a0f6c7d493a7190ea4b9a85e335b33489d9f17e0245e"
  end

  def install
    virtualenv_install_with_resources
    (bash_completion/"pdm").write Utils.safe_popen_read("#{bin}/pdm", "completion", "bash")
    (zsh_completion/"_pdm").write Utils.safe_popen_read("#{bin}/pdm", "completion", "zsh")
    (fish_completion/"pdm.fish").write Utils.safe_popen_read("#{bin}/pdm", "completion", "fish")
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"

    EOS
    system bin/"pdm", "add", "requests==2.24.0"
    assert_match "dependencies = [\n    \"requests==2.24.0\",\n]", (testpath/"pyproject.toml").read
    assert_predicate testpath/"pdm.lock", :exist?
    assert_match "name = \"urllib3\"", (testpath/"pdm.lock").read
    output = shell_output("#{bin}/pdm run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
