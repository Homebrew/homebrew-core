class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package and dependency manager supporting the latest PEP standards"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/4b/6b/8363b9dca9039674b9bbbe4f57f9f0ed775b150c80ba2d1319862e0d9f02/pdm-2.4.9.tar.gz"
  sha256 "dbc6ffb195f39ab24b4bcb507fe99789a61a32159d8bf227f3117b94f327f2f2"
  license "MIT"
  head "https://github.com/pdm-project/pdm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c99443538e66842d4b26bccd1ccee9d09b752239cdfeb0bda6c2c494af11ec4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09123cdd44bb9446dcffdefb64c892df259e43bd12b9ff37dc9fded47c5810d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cd69aebbae9763df4d881232c2e088db92c9ca1971a038bb5af7ca0ebe2f2f7"
    sha256 cellar: :any_skip_relocation, ventura:        "815f208004c7bc8a89fc631dfec19a15707c4765c1665ef8ce5be5915ec343f0"
    sha256 cellar: :any_skip_relocation, monterey:       "d2a882a3ab7f1b874b0ac22c4a81d8524e9b01dabcfe93e0f4bcd1c09f532e2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "814dcf70fbe0a1b458c7b9a5f9a66e67aedab78c7c67c72d10af34f9e4a67118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf00c0af40cbaa30965b90e7a6144e29166ed24ae98d8c48909c29859df1953b"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/2b/12/82786486cefb68685bb1c151730f510b0f4e5d621d77f245bc0daf9a6c64/blinker-1.5.tar.gz"
    sha256 "923e5e2f69c155f2cc42dafbbd70e16e3fde24d2d4aa2ab72fbe386238892462"
  end

  resource "CacheControl" do
    url "https://files.pythonhosted.org/packages/06/80/1f8ba1ced5f29514d8621003b2b0fb404ed88996e963dbca7f519ecc82ca/CacheControl-0.12.12.tar.gz"
    sha256 "9c2e5208ea76ebd9921176569743ddf6d7f3bb4188dbf61806f0f8fc48ecad38"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/4f/1f/6e1b740698069650b245744957a25957d599b953550a959ab2a584a8825b/filelock-3.10.0.tar.gz"
    sha256 "3199fd0d3faea8b911be52b663dfccceb84c95949dd13179aa21436d1a79c4ce"
  end

  resource "findpython" do
    url "https://files.pythonhosted.org/packages/21/1a/fa0e5e87180e15a417c6102c4f557398ce5edbfa4416d6ed981c2bdef6e6/findpython-0.2.4.tar.gz"
    sha256 "61f1768cdd843dc2f8a45971272c58c25641a50b19da91302e2492e32a667362"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/c9/ab/a9141dc175ec7b620fffe7e0295251a7b6a0ffb4325d64aeb128dff8c698/installer-0.6.0.tar.gz"
    sha256 "f3bd36cd261b440a88a1190b1becca0578fee90b4b62decc796932fdd5ae8839"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/e4/c0/59bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7/markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/dc/a1/eba11a0d4b764bc62966a565b470f8c6f38242723ba3057e9b5098678c30/msgpack-1.0.5.tar.gz"
    sha256 "c075544284eadc5cddc70f4757331d99dcbc16b2bbd4849d15f8aae4cf36d31c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/79/c4/f98a05535344f79699bbd494e56ac9efc986b7a253fe9f4dba7414a7f505/platformdirs-3.1.1.tar.gz"
    sha256 "024996549ee88ec1a9aa99ff7f8fc819bb59e2c3477b410d90a16d32d6e707aa"
  end

  resource "pyproject_hooks" do
    url "https://files.pythonhosted.org/packages/25/c1/374304b8407d3818f7025457b7366c8e07768377ce12edfe2aa58aa0f64c/pyproject_hooks-1.0.0.tar.gz"
    sha256 "f271b298b97f5955d53fb12b72c1fb1948c22c1a6b70b315c54cedaca0264ef5"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/31/06/1ef763af20d0572c032fa22882cfbfb005fba6e7300715a37840858c919e/python-dotenv-1.0.0.tar.gz"
    sha256 "a8df96034aae6d2d50a4ebe8216326c61c3eb64836776504fcca410e5937a3ba"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/0c/4c/07f01c6ac44f7784fa399137fbc8d0cdc1b5d35304e8c0f278ad82105b58/requests-toolbelt-0.10.1.tar.gz"
    sha256 "62e09f7ff5ccbda92772a29f394a49c3ad6cb181d568b1337626b2abb628a63d"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/73/51/36f96ad70dd8c71274ac77739cda0794fee3ba45640373e7f8c5da7c9455/resolvelib-0.9.0.tar.gz"
    sha256 "40ab05117c3281b1b160105e10075094c5ab118315003c922b77673a365290e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/5e/0e/ef0a49be56dbc4052a086888cd2490e15fcc95b0eda79e9d0e737b1ab93d/rich-13.3.2.tar.gz"
    sha256 "91954fe80cfb7985727a467ca98a7618e5dd15178cc2da10f553b36a93859001"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/1b/b5/8a4ebd9108ab4f78e697a901969f3c3bf27afddf734a4b8a2e7dd7d440e3/shellingham-1.5.1.tar.gz"
    sha256 "41bc81fa8d74afb04338e0398f9732ee2217407ade778ae1e2709bde89d85c45"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/ff/04/58b4c11430ed4b7b8f1723a5e4f20929d59361e9b17f0872d69681fd8ffd/tomlkit-0.11.6.tar.gz"
    sha256 "71b952e5721688937fb02cf9d354dbcf0785066149d2855e44531ebdd2b65d73"
  end

  resource "unearth" do
    url "https://files.pythonhosted.org/packages/b4/b2/104164436e7cbdd9db5524fe89055ccb51385570df30f278b7421e5bda5a/unearth-0.8.1.tar.gz"
    sha256 "62d3493619d181746c0e0586dfcf6cef957b95f4d3b042698eda312fdbf0617b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/87/14/ca9890d58cd33d9122eb87ffec2f3c6be0714785f992a0fd3b56a3b6c993/virtualenv-20.21.0.tar.gz"
    sha256 "f50e3e60f990a0757c9b68333c9fdaa72d7188caa417f96af9e52407831a3b68"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/fc/ef/0335f7217dd1e8096a9e8383e1d472aa14717878ffe07c4772e68b6e8735/wheel-0.40.0.tar.gz"
    sha256 "cd1196f3faee2b31968d626e1731c94f99cbdb67cf5a46e4f5656cbee7738873"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"pdm", "completion")
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

      [build-system]
      requires = ["pdm-pep517>=0.12.0"]
      build-backend = "pdm.pep517.api"

    EOS
    system bin/"pdm", "add", "requests==2.24.0"
    assert_match "dependencies = [\n    \"requests==2.24.0\",\n]", (testpath/"pyproject.toml").read
    assert_predicate testpath/"pdm.lock", :exist?
    assert_match "name = \"urllib3\"", (testpath/"pdm.lock").read
    output = shell_output("#{bin}/pdm run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
