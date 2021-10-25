class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package manager with PEP 582 support"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/e9/d5/1210931acc774f40f6d0ffe475b635339df90501bffdbcca66f3921cda97/pdm-1.10.0.tar.gz"
  sha256 "c8b702e1a9cce1dd04f4944269d3c3b8732ff470e3e54694917ca3d923a7c475"
  license "MIT"
  head "https://github.com/pdm-project/pdm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a09037e33c7a2348c5595f19a09d3ed2cc9a4ad3faf2512a2e2d22dd0be9049"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35da3a059f3372cd6bb94db5279f32ccac4f7dd7b9d04c77c7e9140b49edf40b"
    sha256 cellar: :any_skip_relocation, monterey:       "9d6265f954f2651ae22798d737e75a9cd441f58e7f60d8cb751c68d2fd0e652c"
    sha256 cellar: :any_skip_relocation, big_sur:        "885b3389c75720a66463e8885bb3f0fcb2c3afb261ec6c7e3a03888312803d0f"
    sha256 cellar: :any_skip_relocation, catalina:       "b8ef3b8bcb952530d70cd93b52b0e5afe220292a07f9d08bf207da6fb27af646"
    sha256 cellar: :any_skip_relocation, mojave:         "10c29403bfa7ed15876d634a6e28c85a0b503674bc2e01bbc34b815bb7b49b87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ab43b7110dba355f98d0aada68b7ffdbf5c951b760eb21b56b57dd3782dee38"
  end

  depends_on "python@3.10"
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
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/3c/b2/43a6ba5ca6d387adbb63a947a6123324e6f4a91932e0b2b739c3b8417610/installer-0.3.0.tar.gz"
    sha256 "e7dc5ec8b737fe3fa7c1872a6ebe120d7abc7cf780aa39af669c382a0fcb6de7"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/86/aef78bab3afd461faecf9955a6501c4999933a48394e90f03cd512aad844/packaging-21.0.tar.gz"
    sha256 "7dc96269f53a4ccec5c0670940a4281106dd0bb343f47b7471f779df49c2fbe7"
  end

  resource "pdm-pep517" do
    url "https://files.pythonhosted.org/packages/93/17/4f0d9661125d8c41be33bd113aa5e260934e6e92aea28069230804bb7035/pdm-pep517-0.8.5.tar.gz"
    sha256 "0adbae8c41947dfc6b81e033f715b533fa5a69180b8c9667a6b8d67e319559d5"
  end

  resource "pep517" do
    url "https://files.pythonhosted.org/packages/0a/65/6e656d49c679136edfba25f25791f45ffe1ea4ae2ec1c59fe9c35e061cd1/pep517-0.12.0.tar.gz"
    sha256 "931378d93d11b298cf511dd634cf5ea4cb249a28ef84160b3247ee9afb4e8ab0"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/31/c9/b29ea153b9bffaae787ecc81873b4b51bd36cc13c37586b41891beae37eb/pyparsing-3.0.1.tar.gz"
    sha256 "84196357aa3566d64ad123d7a3c67b0e597a115c4934b097580e5ce220b91531"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/36/b7/08860463445e6f3b4c5ac24717ce0e8a2f6e9dbc329b0e5d148094ce89ec/python-dotenv-0.19.1.tar.gz"
    sha256 "14f8185cc8d494662683e6914addcb7e95374771e707601dfc70166946b4c4b8"
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
    url "https://files.pythonhosted.org/packages/aa/5b/62165da80cbc6e1779f342234c7ddc6c6bc9e64cef149046a9c0456f912b/tomli-1.2.2.tar.gz"
    sha256 "c6ce0015eb38820eaf32b5db832dbc26deb3dd427bd5f6556cf0acac2c214fee"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/4e/be/8139f127b4db2f79c8b117c80af56a3078cc4824b5b94250c7f81a70e03b/wheel-0.37.0.tar.gz"
    sha256 "e2ef7239991699e3355d54f8e968a21bb940a1dbf34a4d226741e64462516fad"
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
