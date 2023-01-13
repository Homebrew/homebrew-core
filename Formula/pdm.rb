class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package and dependency manager supporting the latest PEP standards"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/94/db/326cb4811a33a27e6326744e19efd880aaed405df834e9917484fad4d4ce/pdm-2.4.0.tar.gz"
  sha256 "22246d27bb60afd7b25a1c1307047867dd280dbd7acb1168d447924c5282f29c"
  license "MIT"
  head "https://github.com/pdm-project/pdm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e3a67d73fb1ec7ff5d1aaaf152e16dbf5169dce370f775827a9ee42c5cb7486"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8deebb4ede4865a7577ff014dca7dac7dee521fd1604e31d33134f716956e7a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e8a167e08a0007215e1dfbeef3f04b32c13a33e67ce562c2d4235fa4106818e"
    sha256 cellar: :any_skip_relocation, ventura:        "9578e5f0ca2965ef2a4f07d50fa37d64f913f323ac3ca0f073ae0415bba37119"
    sha256 cellar: :any_skip_relocation, monterey:       "ae8a4a23065841d265f19da4d97cc87b5ef80478953f50cc13129d98fe989ef8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b56dcee1594c1f01e615fa51ac7ab5f5436c1410898cd8395d60b1741a5e8d02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8933114889c50bf17509925bc42f3ebd26b6251a050465d25c22c3ee8c1f08e4"
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
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0b/dc/eac02350f06c6ed78a655ceb04047df01b02c6b7ea3fc02d4df24ca87d24/filelock-3.9.0.tar.gz"
    sha256 "7b319f24340b51f55a2bf7a12ac0755a9b03e718311dac567a0f4f7fabd2f5de"
  end

  resource "findpython" do
    url "https://files.pythonhosted.org/packages/28/96/ec16612c4384cfca9381239d06e9285ca41d749d4a5003df73e3a96255e7/findpython-0.2.2.tar.gz"
    sha256 "80557961c04cf1c8c4ba4ca3ac7cf76ec27fa92788a6af42cb701e3450c49430"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/c9/ab/a9141dc175ec7b620fffe7e0295251a7b6a0ffb4325d64aeb128dff8c698/installer-0.6.0.tar.gz"
    sha256 "f3bd36cd261b440a88a1190b1becca0578fee90b4b62decc796932fdd5ae8839"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/22/44/0829b19ac243211d1d2bd759999aa92196c546518b0be91de9cacc98122a/msgpack-1.0.4.tar.gz"
    sha256 "f5d869c18f030202eb412f08b28d2afeea553d6613aee89e200d7aca7ef01f5f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/4d/198b7e6c6c2b152f4f9f4cdf975d3590e33e63f1920f2d89af7f0390e6db/platformdirs-2.6.2.tar.gz"
    sha256 "e1fea1fe471b9ff8332e229df3cb7de4f53eeea4998d3b6bfff542115e998bd2"
  end

  resource "pyproject_hooks" do
    url "https://files.pythonhosted.org/packages/25/c1/374304b8407d3818f7025457b7366c8e07768377ce12edfe2aa58aa0f64c/pyproject_hooks-1.0.0.tar.gz"
    sha256 "f271b298b97f5955d53fb12b72c1fb1948c22c1a6b70b315c54cedaca0264ef5"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/87/8d/ab7352188f605e3f663f34692b2ed7457da5985857e9e4c2335cd12fb3c9/python-dotenv-0.21.0.tar.gz"
    sha256 "b77d08274639e3d34145dfa6c7008e66df0f04b7be7a75fd0d5292c191d79045"
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
    url "https://files.pythonhosted.org/packages/2f/1a/91f38976d2ed0b955e683fdbaafebf94606ff238b1ef604438a06a6d695f/rich-13.0.1.tar.gz"
    sha256 "25f83363f636995627a99f6e4abc52ed0970ebbd544960cc63cbb43aaac3d6f0"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/1f/13/fab0a3f512478bc387b66c51557ee715ede8e9811c77ce952f9b9a4d8ac1/shellingham-1.5.0.post1.tar.gz"
    sha256 "823bc5fb5c34d60f285b624e7264f4dda254bc803a3774a147bf99c0e3004a28"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/ff/04/58b4c11430ed4b7b8f1723a5e4f20929d59361e9b17f0872d69681fd8ffd/tomlkit-0.11.6.tar.gz"
    sha256 "71b952e5721688937fb02cf9d354dbcf0785066149d2855e44531ebdd2b65d73"
  end

  resource "unearth" do
    url "https://files.pythonhosted.org/packages/67/97/1ec0064708bf8fb7d494487f1523e38a8de56cfc98ce537fb06c8e092d6b/unearth-0.7.2.tar.gz"
    sha256 "e2341ba7b99e431955a10cd3da0c15ab0d42a5f9cb3f1e3f460df42bc3396dcf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/7b/19/65f13cff26c8cc11fdfcb0499cd8f13388dd7b35a79a376755f152b42d86/virtualenv-20.17.1.tar.gz"
    sha256 "f8b927684efc6f1cc206c9db297a570ab9ad0e51c16fa9e45487d36d1905c058"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/a2/b8/6a06ff0f13a00fc3c3e7d222a995526cbca26c1ad107691b6b1badbbabf1/wheel-0.38.4.tar.gz"
    sha256 "965f5259b566725405b05e7cf774052044b1ed30119b5d586b2703aafe8719ac"
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
