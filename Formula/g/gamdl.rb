class Gamdl < Formula
  include Language::Python::Virtualenv

  desc "Python CLI app for downloading Apple Music songs, music videos and post videos"
  homepage "https://github.com/glomatico/gamdl"
  url "https://files.pythonhosted.org/packages/ab/83/005bdeb037dc68bf7b0a79c2b4e6c16958ba66b52f51d8dd6fb81e3d82e5/gamdl-3.8.4.tar.gz"
  sha256 "c0fd711aa6bae8f0ff3ff413c14af92812b5a7bbcd67a2fd0f9600d24994c091"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0c953da91ef00534ad0a64286530dcb2bf97feace5dea3903acfa97ab0df7bba"
    sha256 cellar: :any, arm64_sequoia: "38bd48a79cb2b9c4f608d0bc33e5e63d8ad0cea47247a2a35c39c01b4b74da64"
    sha256 cellar: :any, arm64_sonoma:  "cf6dc9d5284f56987b645369c39d266d1da8da831cf388d676c926a26f0ace8f"
    sha256 cellar: :any, sonoma:        "e6cfcea3104754e0a613982aacf7985ba8c9039a4720d105b63d6799b4f09407"
    sha256 cellar: :any, arm64_linux:   "e2c10cf1e395903bafd383739a73dbf47ac40f6e2ee7165b6940562c547c3dfb"
    sha256 cellar: :any, x86_64_linux:  "f886b1ba5ff491575bdbe61b572c8d86ff48072d208bb4d7b0d542f210f6a1fb"
  end

  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi pillow]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "async-lru" do
    url "https://files.pythonhosted.org/packages/e8/1f/989ecfef8e64109a489fff357450cb73fa73a865a92bd8c272170a6922c2/async_lru-2.3.0.tar.gz"
    sha256 "89bdb258a0140d7313cf8f4031d816a042202faa61d0ab310a0a538baa1c24b6"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
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

  resource "httpx-retries" do
    url "https://files.pythonhosted.org/packages/e9/d3/b7a8bb09543af40009717a08a2ceba90b6d4c6f0cdf171404217d8f4c37d/httpx_retries-0.6.0.tar.gz"
    sha256 "3e0b404969a564829d368417964fd21e6b400a10d17c92d29b8bc247ce8186e3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
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
    url "https://files.pythonhosted.org/packages/df/70/1675da133ea92227da41bf5b24e1c66be597ff736a1533ade41da986852f/mutagen-1.48.1.tar.gz"
    sha256 "8f95637ab9f6f305cec6bd1294e197debe207998e3e068596563c74f86b0a173"
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
    url "https://files.pythonhosted.org/packages/66/70/e908e9c5e52ef7c3a6c7902c9dfbb34c7e29c25d2f81ade3856445fd5c94/protobuf-6.33.6.tar.gz"
    sha256 "a6768d25248312c297558af96a9f9c929e8c4cee0659cb07e780731095f38135"
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
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/5e/89/b4a0bcfdf4f71a3dea31379f095929613d7e4528a0996bca6aa964cd0dca/structlog-26.1.0.tar.gz"
    sha256 "f63a716cbd1b1291cf7661de7794b455acfa4c43c5bcf1630e6ad5ddc1adb3b7"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/47/c5/9972af4b472b0d55badf841ebafd2f98944cb0ae0f46e11d01f363ea5b91/yt_dlp-2026.7.4.tar.gz"
    sha256 "b094813404f87a9dd2186f00815231df32e5fd8a5403be0f807b3bb2d21a4432"
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
