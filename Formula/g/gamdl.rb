class Gamdl < Formula
  include Language::Python::Virtualenv

  desc "Python CLI app for downloading Apple Music songs, music videos and post videos"
  homepage "https://github.com/glomatico/gamdl"
  url "https://files.pythonhosted.org/packages/76/62/28429c8edd8667ba9012678d3c467304907e12d793e16e8d454b89c44f3f/gamdl-2.9.3.tar.gz"
  sha256 "a053d0801103df676af6effd348f068f2bdca51ab85551fc6aa56b684e5ffdd3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a1f739cf007c787d4557296b2b057a931f9bd3fa205e48a1e9a3a6436d400598"
    sha256 cellar: :any,                 arm64_sequoia: "7d370fe37b5958131d39e5817ce5d492f3baeac1c601158418bc2315ac466d4c"
    sha256 cellar: :any,                 arm64_sonoma:  "f3190a138268759f960d6277d535c62645e8e811d6f04b2b1b26acca0a3c25b8"
    sha256 cellar: :any,                 sonoma:        "1b26f930257378353236e3786c34d9956cafccc2c72506734f90c69a019956bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f144019060674af0defa4839b1e6c85ff6a3a4489eaf78acf652de906ffd2d8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "664cd2387cef766f537796aec4565ae8565067178e875ac0b24809a1149d9ea5"
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
    url "https://files.pythonhosted.org/packages/05/8a/ca724066c32a53fa75f59e0f21aa822fdaa8a0dffa112d223634e3caabf9/async_lru-2.2.0.tar.gz"
    sha256 "80abae2a237dbc6c60861d621619af39f0d920aea306de34cb992c879e01370c"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/1d/35/02daf95b9cd686320bb622eb148792655c9412dbb9b67abb5694e5910a24/charset_normalizer-3.4.5.tar.gz"
    sha256 "95adae7b6c42a6c5b5b559b1a99149f090a57128155daeea91732c8d970d8644"
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
    url "https://files.pythonhosted.org/packages/35/a2/8e3becb46433538a38726c948d3399905a4c7cabd0df578ede5dc51f0ec2/wcwidth-0.6.0.tar.gz"
    sha256 "cdc4e4262d6ef9a1a57e018384cbeb1208d8abbc64176027e2c2455c81313159"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/66/6f/7427d23609353e5ef3470ff43ef551b8bd7b166dd4fef48957f0d0e040fe/yt_dlp-2026.3.3.tar.gz"
    sha256 "3db7969e3a8964dc786bdebcffa2653f31123bf2a630f04a17bdafb7bbd39952"
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
