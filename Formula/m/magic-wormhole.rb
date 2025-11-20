class MagicWormhole < Formula
  include Language::Python::Virtualenv

  desc "Securely transfers data between computers"
  homepage "https://github.com/magic-wormhole/magic-wormhole"
  url "https://files.pythonhosted.org/packages/d1/c6/0ed9e0dca81eb5d0bcfc72690613bf26a13b95a9edb95fc35cebbfff8fba/magic_wormhole-0.21.1.tar.gz"
  sha256 "b6d35972a19b4baa44e022518317b4e0ad26709fa019196f67ca0d127672a367"
  license "MIT"
  head "https://github.com/magic-wormhole/magic-wormhole.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c879c1ae9106ab6a889c3dfdc4e7f3126cbbd480241c8ae41f842709670a2e26"
    sha256 cellar: :any,                 arm64_sequoia: "af3bb7433c2a0d4397c58e689ab901ce85ddc50ca45f9dc334bd4852e87dcab8"
    sha256 cellar: :any,                 arm64_sonoma:  "dfb8965171d794135d082d44ded0ddb6a37c984c51b01e685f1b8a17976a1f72"
    sha256 cellar: :any,                 sonoma:        "48dd3b253a320347168b33a5012a8381777a8cd97531b40a320bf7a10bb6ca7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37d0c091a5cc3cd58bb3b753f554c14fe0a9762118f2f6a7a629f180cce7a037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a61206f798ca2b59525bcd9e6f8e6513a592d859be3160c00ca4744192250e8"
  end

  depends_on "cryptography" => :no_linkage
  depends_on "libsodium"
  depends_on "python@3.14"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: "cryptography"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "autobahn" do
    url "https://files.pythonhosted.org/packages/38/f2/8dffb3b709383ba5b47628b0cc4e43e8d12d59eecbddb62cfccac2e7cf6a/autobahn-24.4.2.tar.gz"
    sha256 "a2d71ef1b0cf780b6d11f8b205fd2c7749765e65795f2ea7d823796642ee92c9"
  end

  resource "automat" do
    url "https://files.pythonhosted.org/packages/e3/0f/d40bbe294bbf004d436a8bcbcfaadca8b5140d39ad0ad3d73d1a8ba15f14/automat-25.4.16.tar.gz"
    sha256 "0017591a5477066e90d26b0e696ddc143baafd87b588cfac8100bc6be9634de0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/4d/6f/cb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324d/constantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/b6/43/50033d25ad96a7f3845f40999b4778f753c3901a11808a584fed7c00d9f5/humanize-4.14.0.tar.gz"
    sha256 "2fa092705ea640d605c435b1ca82b2866a1b601cdf96f076d70b79a855eba90d"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
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
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/06/c6/a3124dee667a423f2c637cfd262a54d67d8ccf3e160f3c50f622a85b7723/pynacl-1.6.0.tar.gz"
    sha256 "cb36deafe6e2bce3b286e5d1f3e1c246e0ccdb8808ddb4550bb2792f2df298f2"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/80/be/97b83a464498a79103036bc74d1038df4a7ef0e402cfaf4d5e113fb14759/pyopenssl-25.3.0.tar.gz"
    sha256 "c981cb0a3fd84e8602d7afc209522773b94c1c2446a3c710a75b06fe1beae329"
  end

  resource "qrcode" do
    url "https://files.pythonhosted.org/packages/8f/b2/7fc2931bfae0af02d5f53b174e9cf701adbb35f39d69c2af63d4a39f81a9/qrcode-8.2.tar.gz"
    sha256 "35c3f2a4172b33136ab9f6b3ef1c00260dd2f66f858f24d88418a015f446506c"
  end

  resource "service-identity" do
    url "https://files.pythonhosted.org/packages/07/a5/dfc752b979067947261dbbf2543470c58efe735c3c1301dd870ef27830ee/service_identity-24.2.0.tar.gz"
    sha256 "b8683ba13f0d39c6cd5d625d2c5f65421d6d707b013b375c355751557cbe8e09"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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
    url "https://files.pythonhosted.org/packages/13/0f/82716ed849bf7ea4984c21385597c949944f0f9b428b5710f79d0afc084d/twisted-25.5.0.tar.gz"
    sha256 "1deb272358cb6be1e3e8fc6f9c8b36f78eb0fa7c2233d2dbe11ec6fee04ea316"
  end

  resource "txaio" do
    url "https://files.pythonhosted.org/packages/2b/20/2e7ccea9ab2dd824d0bd421d9364424afde3bb33863afb80cd9180335019/txaio-25.9.2.tar.gz"
    sha256 "e42004a077c02eb5819ff004a4989e49db113836708430d59cb13d31bd309099"
  end

  resource "txtorcon" do
    url "https://files.pythonhosted.org/packages/b9/9f/7815b07d8bc775d9578d9131267bb7ce3e91e31305688736ed796ae724d1/txtorcon-24.8.0.tar.gz"
    sha256 "befe19138d9c8c5307b6ee6d4fe446d0c201ffd1cc404aeb265ed90309978ad0"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "zipstream-ng" do
    url "https://files.pythonhosted.org/packages/11/f2/690a35762cf8366ce6f3b644805de970bd6a897ca44ce74184c7b2bc94e7/zipstream_ng-1.9.0.tar.gz"
    sha256 "a0d94030822d137efbf80dfdc680603c42f804696f41147bb3db895df667daea"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/88/3a/7fcf02178b8fad0a51e67e32765cd039ae505d054d744d76b8c2bbcba5ba/zope_interface-8.0.1.tar.gz"
    sha256 "eba5610d042c3704a48222f7f7c6ab5b243ed26f917e2bc69379456b115e02d1"
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
