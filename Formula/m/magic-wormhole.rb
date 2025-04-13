class MagicWormhole < Formula
  include Language::Python::Virtualenv

  desc "Securely transfers data between computers"
  homepage "https://github.com/magic-wormhole/magic-wormhole"
  url "https://files.pythonhosted.org/packages/18/a5/aa48cfccc9c823678506b27892dbc6f4646ec5474c43676e4f1990efa106/magic-wormhole-0.18.0.tar.gz"
  sha256 "66fdee0861ec63ab494560aa1c68ebe3b21e955d0cabd84eadf93013e332852c"
  license "MIT"
  head "https://github.com/magic-wormhole/magic-wormhole.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e745711c8cbe84fbc091ec9fd6f8faa83f5fcfda96b6f2e3d4a37dbd5257b741"
    sha256 cellar: :any,                 arm64_sonoma:  "162ec34aa32ed8a20e74a1677bd32c59b8e48bd21be45b43be9176b417d8ebad"
    sha256 cellar: :any,                 arm64_ventura: "486ff65f25c563874cd1ffd5ed45fd2986b8d12cd10381b44b01df13aa820239"
    sha256 cellar: :any,                 sonoma:        "0bda90dd409da246fe2df1e708a8a868d6426b3b69e9cfc5eac2eb09e48d8246"
    sha256 cellar: :any,                 ventura:       "3163b1f39f3cf563b372f08e983496766fe5e55face13ae73af7f27c18f6273d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c70fc25eb831ff8663e69d7998a9663da06c9cce3805aac6b2742452dfbcb54d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a07e42aedd93126145047c115948f86cb29c1e0f084fcdb8031c961ed87d2f1f"
  end

  depends_on "cryptography"
  depends_on "libsodium"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/49/7c/fdf464bcc51d23881d110abd74b512a42b3d5d376a55a831b44c603ae17f/attrs-25.1.0.tar.gz"
    sha256 "1c97078a80c814273a76b2a298a932eb681c87415c11dee0a6921de7f1b02c3e"
  end

  resource "autobahn" do
    url "https://files.pythonhosted.org/packages/38/f2/8dffb3b709383ba5b47628b0cc4e43e8d12d59eecbddb62cfccac2e7cf6a/autobahn-24.4.2.tar.gz"
    sha256 "a2d71ef1b0cf780b6d11f8b205fd2c7749765e65795f2ea7d823796642ee92c9"
  end

  resource "automat" do
    url "https://files.pythonhosted.org/packages/8d/2d/ede4ad7fc34ab4482389fa3369d304f2fa22e50770af706678f6a332fa82/automat-24.8.1.tar.gz"
    sha256 "b34227cf63f6325b8ad2399ede780675083e439b20c323d376373d8ee6306d88"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/4d/6f/cb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324d/constantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/5b/8c/4f2f0784d08a383b5de3d3b1d65a6f204cc5dc487621c91c550388d756af/humanize-4.12.1.tar.gz"
    sha256 "1338ba97415c96556758a6e2f65977ed406dddf4620d4c6db9bbdfd07f0f1232"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/27/87/156b374ff6578062965afe30cc57627d35234369b3336cf244b240c8d8e6/incremental-24.7.2.tar.gz"
    sha256 "fb4f1d47ee60efe87d4f6f0ebb5f70b9760db2b2574c59c8e8912be4ebd464c9"
  end

  resource "iterable-io" do
    url "https://files.pythonhosted.org/packages/40/be/27d59b5c1d74ecbd26c1142f84b61d6cb04f0d0337697149645f34406b2d/iterable-io-1.0.0.tar.gz"
    sha256 "fb9e1b739587a9ba0d5c60a3e1eb71246761583bc9f18b3c35bb112b44b18c3c"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/1d/67/6afbf0d507f73c32d21084a79946bfcfca5fbc62a72057e9c23797a737c9/pyasn1_modules-0.4.1.tar.gz"
    sha256 "c28e2dbf9c06ad61c71a075c7e0f9fd0f1b0bb2d2ad4377f240d33ac2ab60a7c"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/9f/26/e25b4a374b4639e0c235527bbe31c0524f26eda701d79456a7e1877f4cc5/pyopenssl-25.0.0.tar.gz"
    sha256 "cd2cef799efa3936bb08e8ccb9433a575722b9dd986023f1cabc4ae64e9dac16"
  end

  resource "qrcode" do
    url "https://files.pythonhosted.org/packages/d7/db/6fc9631cac1327f609d2c8ae3680ecd987a2e97472437f2de7ead1235156/qrcode-8.0.tar.gz"
    sha256 "025ce2b150f7fe4296d116ee9bad455a6643ab4f6e7dce541613a4758cbce347"
  end

  resource "service-identity" do
    url "https://files.pythonhosted.org/packages/07/a5/dfc752b979067947261dbbf2543470c58efe735c3c1301dd870ef27830ee/service_identity-24.2.0.tar.gz"
    sha256 "b8683ba13f0d39c6cd5d625d2c5f65421d6d707b013b375c355751557cbe8e09"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/32/d2/7b171caf085ba0d40d8391f54e1c75a1cda9255f542becf84575cfd8a732/setuptools-76.0.0.tar.gz"
    sha256 "43b4ee60e10b0d0ee98ad11918e114c70701bc6051662a9a675a0496c1a158f4"
  end

  resource "spake2" do
    url "https://files.pythonhosted.org/packages/c5/4b/32ad65f8ff5c49254e218ccaae8fc16900cfc289954fb372686159ebe315/spake2-0.9.tar.gz"
    sha256 "421fc4a8d5ac395af7af0206ffd9e6cdf188c105cb1b883d9d683312bb5a9334"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "twisted" do
    url "https://files.pythonhosted.org/packages/77/1c/e07af0df31229250ab58a943077e4adbd5e227d9f2ac826920416b3e5fa2/twisted-24.11.0.tar.gz"
    sha256 "695d0556d5ec579dcc464d2856b634880ed1319f45b10d19043f2b57eb0115b5"
  end

  resource "txaio" do
    url "https://files.pythonhosted.org/packages/51/91/bc9fd5aa84703f874dea27313b11fde505d343f3ef3ad702bddbe20bfd6e/txaio-23.1.1.tar.gz"
    sha256 "f9a9216e976e5e3246dfd112ad7ad55ca915606b60b84a757ac769bd404ff704"
  end

  resource "txtorcon" do
    url "https://files.pythonhosted.org/packages/b9/9f/7815b07d8bc775d9578d9131267bb7ce3e91e31305688736ed796ae724d1/txtorcon-24.8.0.tar.gz"
    sha256 "befe19138d9c8c5307b6ee6d4fe446d0c201ffd1cc404aeb265ed90309978ad0"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "zipstream-ng" do
    url "https://files.pythonhosted.org/packages/ac/16/5d9224baf640214255c34a0a0e9528c8403d2b89e2ba7df9d7cada58beb1/zipstream_ng-1.8.0.tar.gz"
    sha256 "b7129d2c15d26934b3e1cb22256593b6bdbd03c553c26f4199a5bf05110642bc"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/30/93/9210e7606be57a2dfc6277ac97dcc864fd8d39f142ca194fdc186d596fda/zope.interface-7.2.tar.gz"
    sha256 "8b49f1a3d1ee4cdaf5b32d2e738362c7f5e40ac8b46dd7d1a65e82a4872728fe"
  end

  def install
    virtualenv_install_with_resources
    man1.install "docs/wormhole.1"
    bash_completion.install "wormhole_complete.bash"=> "wormhole"
    fish_completion.install "wormhole_complete.fish" => "wormhole.fish"
    zsh_completion.install "wormhole_complete.zsh" => "_wormhole"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    n = rand(1e6)
    pid = spawn bin/"wormhole", "send", "--code=#{n}-homebrew-test", "--text=foo"
    begin
      sleep 1
      assert_match "foo\n", shell_output("#{bin}/wormhole receive #{n}-homebrew-test")
    ensure
      Process.wait(pid)
    end
  end
end
