class Hatch < Formula
  include Language::Python::Virtualenv

  desc "Modern, extensible Python project management"
  homepage "https://hatch.pypa.io/latest/"
  url "https://files.pythonhosted.org/packages/17/98/63bf6c592b65f67201db292489053b86310cfb107eb095d345398e00cbd3/hatch-1.9.4.tar.gz"
  sha256 "9bb7d1c4a7a51cc1f9e16394875c940b45fa84b698f0291529316b27d74e7f32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07ca960c8a1db653627dbf68717136cdfd522982e8b4e6099bbb579d9027ed1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7787fca6338ff5540b22b2561c0c72d3c2e6815c034366ea9ccd4969b891d0a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7528e30497a3685487e1175cc52a21d34cd63af51fe2783a937cd00b5d0feae"
    sha256 cellar: :any_skip_relocation, sonoma:         "079f570d40c6b794fc10169863806f29180a9ac63c986165fec205f9ca5f0a6d"
    sha256 cellar: :any_skip_relocation, ventura:        "b56ba40ae48fed18a0b70ea14f25fd26e15999a04f2ecc1af21aee622ce8a3f5"
    sha256 cellar: :any_skip_relocation, monterey:       "524baed9ad26b511b84d2118b1d3b202c0ffa537d895c0b9a93fcd2c1b5fe6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72f577276681521dea1ec570135aee2c13d44a3f1125acfa0dd975df7e085274"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  on_linux do
    depends_on "cffi"
    depends_on "pycparser"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/db/4d/3970183622f0330d3c23d9b8a5f52e365e50381fd484d08e3285104333d3/anyio-4.3.0.tar.gz"
    sha256 "f75253795a87df48568485fd18cdd2a3fa5c4f7c5be8e5e36637733fce06fed6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "editables" do
    url "https://files.pythonhosted.org/packages/37/4a/986d35164e2033ddfb44515168a281a7986e260d344cf369c3f52d4c3275/editables-0.5.tar.gz"
    sha256 "309627d9b5c4adc0e668d8c6fa7bac1ba7c8c5d415c2d27f60f081f8e80d1de2"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/d8/a1/7dd1caa87c0b15c04c6291e25112e5d082cce02ee87f221a8be1d594f857/hatchling-1.21.1.tar.gz"
    sha256 "bba440453a224e7d4478457fa2e8d8c3633765bafa02975a6b53b9bf917980bc"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/03/9d/2055e6b65592d3a485a1141761ba7047674bbe085cebac0988b30e93c9e6/httpcore-1.0.4.tar.gz"
    sha256 "cb2839ccfcba0d2d3c1131d3c3e26dfc327326fbe7a5dc0dbfe9f6c9151bb022"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/5c/2d/3da5bdf4408b8b2800061c339f240c1802f2e82d55e50bd39c5a881f47f0/httpx-0.27.0.tar.gz"
    sha256 "a0cb88a46f32dc874e04ee956e4c2764aba2aa228f650b06788ba6bda2962ab5"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/a5/8a/ed955184b2ef9c1eef3aa800557051c7354e5f40a9efc9a46e38c3e6d237/jaraco.classes-3.3.1.tar.gz"
    sha256 "cb28a5ebda8bc47d8c8015307d93163464f9f2b91ab4006e09ff0ce07e8bfb30"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/ae/6c/bd2cfc6c708ce7009bdb48c85bb8cad225f5638095ecc8f49f15e8e1f35e/keyring-24.3.1.tar.gz"
    sha256 "c3327b6ffafc0e8befbdb597cacdb4928ffe5c1212f7645f186e6d9957a898db"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/df/ad/7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4/more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/54/c6/43f9d44d92aed815e781ca25ba8c174257e27253a94630d21be8725a2b59/pluggy-1.4.0.tar.gz"
    sha256 "8c85c2876142a764e5b7548e7d9a0e0ddb46f5185161049a79b7e974454223be"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/7d/49/4c0764898ee67618996148bdba4534a422c5e698b4dbf4001f7c6f930797/tomlkit-0.12.4.tar.gz"
    sha256 "7ca1cfc12232806517a8515047ba66a19369e71edf2439d0f5824f91032b6cc3"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/13/11/e13906315b498cb8f5ce5a7ff39fc35941e8291e914158157937fd1c095d/trove-classifiers-2024.3.3.tar.gz"
    sha256 "df7edff9c67ff86b733628998330b180e81d125b1e096536d83ac0fd79673fdc"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/d5/b7/30753098208505d7ff9be5b3a32112fb8a4cb3ddfccbbb7ba9973f2e29ff/userpath-1.9.2.tar.gz"
    sha256 "6c52288dab069257cc831846d15d48133522455d4677ee69a9781f11dbefd815"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/93/4f/a7737e177ab67c454d7e60d48a5927f16cd05623e9dd888f78183545d250/virtualenv-20.25.1.tar.gz"
    sha256 "e08e13ecdca7a0bd53798f356d5831434afa5b07b93f0abdf0797b7a06ffe197"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/5d/91/2162ab4239b3bd6743e8e407bc2442fca0d326e2d77b3f4a88d90ad5a1fa/zstandard-0.22.0.tar.gz"
    sha256 "8226a33c542bcb54cd6bd0a366067b610b41713b64c9abec1bc4533d69f51e70"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"hatch", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    ENV["HATCH_PYTHON"] = "self"
    system bin/"hatch", "new", "homebrew"
    assert_predicate testpath/"homebrew/pyproject.toml", :exist?

    cd testpath/"homebrew" do
      inreplace "pyproject.toml", "dependencies = []", "dependencies = ['requests==2.31.0']"
      system bin/"hatch", "config", "set", "dirs.env.virtual", ".venv"
      system bin/"hatch", "env", "create"
      output = shell_output("#{bin}/hatch env run -- python -c 'import requests;print(requests.__version__)'")
      assert_equal "2.31.0", output.strip.lines.last
    end
  end
end
