class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package manager with PEP 582 support"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/52/d7/a9da4ba600ecb9a26ff505d57213222a0b6154b30998fe132d792f268daf/pdm-1.11.3.tar.gz"
  sha256 "0b2d0275b0319400101e742d67e753917689359c9b1167744122209544de0fb1"
  license "MIT"
  head "https://github.com/pdm-project/pdm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf663f066b093542a6978672dd061cd9366ce3b0e12e1e68a167e5ae126e269d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b6cc9a724089ed084ac6ec826b7c404673ba6ea26e449480cfb902bd247d86f"
    sha256 cellar: :any_skip_relocation, monterey:       "59c5b1769e05a81673925966a1b6c8758bd0190e00103dcc17f39c6aec08f1a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9577cdcba81ddba32a606ce25f5ef3cc5f4b056c6b6b21e57ac507c7aff9c5f7"
    sha256 cellar: :any_skip_relocation, catalina:       "5a9fd2d8f36f6cd1c65ffef3f5747422b21bf741052a57666f9389d41963b6c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "671bc68144388c9b3abca3d16d7e7515391c99b4fae1b579ef0337761815160b"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "atoml" do
    url "https://files.pythonhosted.org/packages/df/bb/d9733f8070c6bb66817a27ec53a0847c63b53395d797d091a477ece5f4c7/atoml-1.1.1.tar.gz"
    sha256 "cda7b3cee4383e37d88e040d9339e75cd257bb1995054046b61d6746f110146c"
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
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pdm-pep517" do
    url "https://files.pythonhosted.org/packages/dd/7c/ac07ce6293258f1d186bc85d686984565c0c8ffbd249faa0855cb5d50a52/pdm-pep517-0.9.4.tar.gz"
    sha256 "da8d85baebd2e4f5bbba1c65dc41813fbe4267775cca33e8ba0d64d22ae5e757"
  end

  resource "pep517" do
    url "https://files.pythonhosted.org/packages/0a/65/6e656d49c679136edfba25f25791f45ffe1ea4ae2ec1c59fe9c35e061cd1/pep517-0.12.0.tar.gz"
    sha256 "931378d93d11b298cf511dd634cf5ea4cb249a28ef84160b3247ee9afb4e8ab0"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/4b/96/d70b9462671fbeaacba4639ff866fb4e9e558580853fc5d6e698d0371ad4/platformdirs-2.4.0.tar.gz"
    sha256 "367a5e80b3d04d2428ffa76d33f124cf11e8fff2acdaa9b43d545f5c7d661ef2"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/49/62/4f25667e10561303a34cb89e3187c35985c0889b99f6f1468aaf17fbb03e/python-dotenv-0.19.2.tar.gz"
    sha256 "a5de49a31e953b45ff2d2fd434bbc2670e8db5273606c1e737cc6b93eff3655f"
  end

  resource "pythonfinder" do
    url "https://files.pythonhosted.org/packages/e5/47/86274134782f8a3aec25a5d27d12243ed5f21e788f0bc3cab597ec170000/pythonfinder-1.2.9.tar.gz"
    sha256 "1a7f756c7f1b47558c9287bce87298c33760ded4552f06b82c28f3f0eee7b91f"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/ac/20/9541749d77aebf66dd92e2b803f38a50e3a5c76e7876f45eb2b37e758d82/resolvelib-0.8.1.tar.gz"
    sha256 "c6ea56732e9fb6fca1b2acc2ccc68a0b6b8c566d8f3e78e0443310ede61dbd37"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/9c/c9/a3e3bc667c8372a74aa4b16649c3466364cd84f7aacb73453c51b0c2c8a7/shellingham-1.4.0.tar.gz"
    sha256 "4855c2458d6904829bd34c299f11fdeed7cfefbf8a2c522e4caea6cd76b3171e"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/3d/6e/d290c9bf16159f02b70c432386aa5bfe22c2857ff460591912fd907b61f6/tomli-2.0.0.tar.gz"
    sha256 "c292c34f58502a1eb2bbb9f5bbc9a5ebc37bee10ffb8c2d6bbdfa8eb13cc14e1"
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
