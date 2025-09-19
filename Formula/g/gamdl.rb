class Gamdl < Formula
  include Language::Python::Virtualenv

  desc "Python CLI app for downloading Apple Music songs, music videos and post videos"
  homepage "https://github.com/glomatico/gamdl"
  url "https://files.pythonhosted.org/packages/1d/1d/c4e76c9f3492a77077aeb87fc33fa94ce43e44facf7d2de2972b1c4957ee/gamdl-2.6.3.tar.gz"
  sha256 "534da0f7fc7e537c9ac3ce198aa778d76a547f6366ac44392c4fca0ebb11cb0a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dc60742cbf2157978f824ccee512528932f58318489c0e39f8819d2e0b570226"
    sha256 cellar: :any,                 arm64_sequoia: "586c03f2aa669adc7d5528bc4e1a43ec253c43ad6c13a054ee17ba6b19832321"
    sha256 cellar: :any,                 arm64_sonoma:  "3a3c81ea1ff0363354ec99fc518b385237e72769e5798014b6377394677d9f8e"
    sha256 cellar: :any,                 sonoma:        "e0b1154721927b2292047a6a302345d7bd003402eba8bd9e95276c0acb1f038d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b892aceac080868e8620416901286efbba25be997cf8c5004a255fc6ef33d596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd75e8342f340f16a7b424e375c7490d2a5948e34d1d66a8e6e16ce73a3e6bc6"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/b6/2c/66bab4fef920ef8caa3e180ea601475b2cbbe196255b18f1c58215940607/construct-2.8.8.tar.gz"
    sha256 "1b84b8147f6fd15bcf64b737c3e8ac5100811ad80c830cb4b2545140511c4157"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
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
    url "https://files.pythonhosted.org/packages/df/01/34c8d2b6354906d728703cb9d546a0e534de479e25f1b581e4094c4a85cc/protobuf-4.25.8.tar.gz"
    sha256 "6135cf8affe1fc6f76cced2641e4ea8d3e59518d1f24ae41ba97bcad82d397cd"
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
    url "https://files.pythonhosted.org/packages/99/12/6ff0e6ffa2711187ee629392396d7c18ae6ca8e2e576dcef2d636316d667/pywidevine-1.8.0.tar.gz"
    sha256 "c14f3fe2864473416b9caa73d9a21251a02d72138e6d54d8c1a3f44b7a6b05c9"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/50/b2/fb255d991857a6a8b2539487ed6063e7bf318f19310d81f039dedb3c2ad6/yt_dlp-2025.9.5.tar.gz"
    sha256 "9ce080f80b2258e872fe8a75f4707ea2c644e697477186e20b9a04d9a9ea37cf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gamdl --version")

    touch testpath/"cookies.txt"
    assert_match "'cookies.txt' does not look like a Netscape format cookies file",
                 shell_output("#{bin}/gamdl fake_url 2>&1", 1)
  end
end
