class Gamdl < Formula
  include Language::Python::Virtualenv

  desc "Python CLI app for downloading Apple Music songs, music videos and post videos"
  homepage "https://github.com/glomatico/gamdl"
  url "https://files.pythonhosted.org/packages/59/c2/c365c924f92f1fa04a6ca158c4333732bc6d5d419a18e549ea7a30319bf1/gamdl-2.8.4.tar.gz"
  sha256 "80e0305f917c4f5dc0e8819ed8f964f30db853758f578726c399e2935cea4ac7"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f0055ee1a46d253c4ada13f130a49295083dd926a1545cdd4f4f84ab999bf44"
    sha256 cellar: :any,                 arm64_sequoia: "f63afa8c6faffac1ef6bd2e85c8313fe4042fc6f6f500db5688785c794b92fc5"
    sha256 cellar: :any,                 arm64_sonoma:  "80577d2f039b7ae20483ea6165edeac58afd6db421bfc654d9a0b630c1b6db9c"
    sha256 cellar: :any,                 sonoma:        "f2b3c0f840ebfc336664addd4b83aaac5106001c7dd8ea079bb50fcdc0ce5813"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db45303429d28ae8d9f182bef80768c331a4bd4b3ed02bb2fb565eae9ea46e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "305dce45a7fa9ae2a6eb6a1f91757d4951ac175721ed5d8b19a1992dacd943a1"
  end

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi pillow]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "async-lru" do
    url "https://files.pythonhosted.org/packages/ef/c3/bbf34f15ea88dfb649ab2c40f9d75081784a50573a9ea431563cab64adb8/async_lru-2.1.0.tar.gz"
    sha256 "9eeb2fecd3fe42cc8a787fc32ead53a3a7158cc43d039c3c55ab3e4e5b2a80ed"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/b6/2c/66bab4fef920ef8caa3e180ea601475b2cbbe196255b18f1c58215940607/construct-2.8.8.tar.gz"
    sha256 "1b84b8147f6fd15bcf64b737c3e8ac5100811ad80c830cb4b2545140511c4157"
  end

  resource "dataclass-click" do
    url "https://files.pythonhosted.org/packages/89/82/5b6035efd90621771fa039960eab3e1ec7ff2a8625033272856843e8bd27/dataclass_click-1.0.4.tar.gz"
    sha256 "10e7de638dd9e68ae9abd5086f61d8ddee42b1873a70f5fd9fd2167856afac11"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "inquirerpy" do
    url "https://files.pythonhosted.org/packages/64/73/7570847b9da026e07053da3bbe2ac7ea6cde6bb2cbd3c7a5a950fa0ae40b/InquirerPy-0.3.4.tar.gz"
    sha256 "89d2ada0111f337483cb41ae31073108b2ec1e618a49d7110b0d7ade89fc197e"
  end

  resource "m3u8" do
    url "https://files.pythonhosted.org/packages/9b/a5/73697aaa99bb32b610adc1f11d46a0c0c370351292e9b271755084a145e6/m3u8-6.0.0.tar.gz"
    sha256 "7ade990a1667d7a653bcaf9413b16c3eb5cd618982ff46aaff57fe6d9fa9c0fd"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
    sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  end

  resource "pfzy" do
    url "https://files.pythonhosted.org/packages/d9/5a/32b50c077c86bfccc7bed4881c5a2b823518f5450a30e639db5d3711952e/pfzy-0.3.4.tar.gz"
    sha256 "717ea765dd10b63618e7298b2d98efd819e0b30cd5905c9707223dceeb94b3f1"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/ba/25/7c72c307aafc96fa87062aa6291d9f7c94836e43214d43722e86037aac02/protobuf-6.33.5.tar.gz"
    sha256 "6ddcac2a081f8b7b9642c09406bc6a4290128fce5f471cddd165960bb9119e5c"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pymp4" do
    url "https://files.pythonhosted.org/packages/a5/46/dfb3f5363fc71adaf419147fdcb93341029ca638634a5cc6f7e7446416b2/pymp4-1.4.0.tar.gz"
    sha256 "bc9e77732a8a143d34c38aa862a54180716246938e4bf3e07585d19252b77bb5"
  end

  resource "pywidevine" do
    url "https://files.pythonhosted.org/packages/52/b6/4855cb958892653029f3cafa8a4724d554b847de0a43a3808cea109b9e78/pywidevine-1.9.0.tar.gz"
    sha256 "6742daf5fd797c5a4813eb1300efb3181ffcddd0c8c478ee28c7c536aa0e51b2"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5f/3e/3d456efe55d2d5e7938b5f9abd68333dd8dceb14e829f51f9a8deed2217e/wcwidth-0.5.2.tar.gz"
    sha256 "c022c39a02a0134d1e10810da36d1f984c79648181efcc70a389f4569695f5ae"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/42/b6/b401777f2fb16cb35bfc352079b8c5a60fbc8189c655539f51a9847d1e0b/yt_dlp-2026.1.29.tar.gz"
    sha256 "12b489eb16828cc3fff1723f244992ebae8a5bf1ad75c8e9f01d729ae237ebb9"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"gamdl", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gamdl --version")

    touch testpath/"cookies.txt"
    assert_match "cookies.txt' does not look like a Netscape format cookies file",
                 shell_output("#{bin}/gamdl fake_url 2>&1", 1)
  end
end
