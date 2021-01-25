class MagicWormhole < Formula
  include Language::Python::Virtualenv

  desc "Securely transfers data between computers"
  homepage "https://github.com/warner/magic-wormhole"
  url "https://files.pythonhosted.org/packages/d4/62/5e4a86f7c4b111e016577f1b304063ebe604f430db15465ac58b13993608/magic-wormhole-0.12.0.tar.gz"
  sha256 "1b0fd8a334da978f3dd96b620fa9b9348cabedf26a87f74baac7a37052928160"
  license "MIT"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "c4d03ce4d4d5484a33b15aac98e878b1a5d656ef6bb7761defc63f9b8af49c99" => :big_sur
    sha256 "0f81451cefc2ee9350fe6723d8d90647a09d794e3a70da938a0aa37e0d9b45bf" => :arm64_big_sur
    sha256 "30739403f4ae594957b0d9559acafa1eabe5056df88c10e3d4647f08f7c3bb98" => :catalina
    sha256 "a953310e7f21176292aa8faef36bc4da7b75b4a3fd76f9a76af8e89c2db58282" => :mojave
  end

  depends_on "libsodium"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/f0/cb/80a4a274df7da7b8baf083249b0890a0579374c3d74b5ac0ee9291f912dc/attrs-20.3.0.tar.gz"
    sha256 "832aa3cde19744e49938b91fea06d69ecb9e649c93ba974535d08ad92164f700"
  end

  resource "autobahn" do
    url "https://files.pythonhosted.org/packages/36/22/5a612815041387e99855fbeed2c803c3bfbb560b48726506418d5e00e6db/autobahn-20.12.3.tar.gz"
    sha256 "410a93e0e29882c8b5d5ab05d220b07609b886ef5f23c0b8d39153254ffd6895"
  end

  resource "Automat" do
    url "https://files.pythonhosted.org/packages/80/c5/82c63bad570f4ef745cc5c2f0713c8eddcd07153b4bee7f72a8dc9f9384b/Automat-20.2.0.tar.gz"
    sha256 "7979803c74610e11ef0c0d68a2942b152df52da55336e0c9d58daf1831cbdf33"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/66/6a/98e023b3d11537a5521902ac6b50db470c826c682be6a8c661549cb7717a/cffi-1.14.4.tar.gz"
    sha256 "1a465cbe98a7fd391d47dce4b8f7e5b921e6cd805ef421d04f5f66ba8f06086c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/95/f1/207a0a478c4bb34b1b49d5915e2db574cadc415c9ac3a7ef17e29b2e8951/constantly-15.1.0.tar.gz"
    sha256 "586372eb92059873e29eba4f9dec8381541b4d3834660707faf8ba59146dfc35"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/b7/82/f7a4ddc1af185936c1e4fa000942ffa8fb2d98cff26b75afa7b3c63391c4/cryptography-3.3.1.tar.gz"
    sha256 "7e177e4bea2de937a584b13645cab32f25e3d96fc0bc4a4cf99c27dc77682be6"
  end

  resource "hkdf" do
    url "https://files.pythonhosted.org/packages/c3/be/327e072850db181ce56afd51e26ec7aa5659b18466c709fa5ea2548c935f/hkdf-0.0.3.tar.gz"
    sha256 "622a31c634bc185581530a4b44ffb731ed208acf4614f9c795bdd70e77991dca"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/64/f1/2fb00b5db6ece093d47fa8d0afc0634683c06bc8f0d0dd2a2457905d8456/humanize-3.2.0.tar.gz"
    sha256 "ab69004895689951b79f2ae4fdd6b8127ff0c180aff107856d5d98119a33f026"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/b7/bf/ecacc60e63d65f7449457bbd8163141c51c4af7aeff7958ec061b8faf915/hyperlink-20.0.1.tar.gz"
    sha256 "47fcc7cd339c6cb2444463ec3277bdcfe142c8b1daf2160bdd52248deec815af"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/9f/24/1444ee2c9aee531783c031072a273182109c6800320868ab87675d147a05/idna-3.1.tar.gz"
    sha256 "c5b02147e01ea9920e6b0a3f1f7bb833612d507592c837a6c49552768f4054e1"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/8f/26/02c4016aa95f45479eea37c90c34f8fab6775732ae62587a874b619ca097/incremental-17.5.0.tar.gz"
    sha256 "7b751696aaf36eebfab537e458929e194460051ccad279c72b755a167eebd4b3"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/88/87/72eb9ccf8a58021c542de2588a867dbefc7556e14b2866d1e40e9e2b587e/pyasn1-modules-0.2.8.tar.gz"
    sha256 "905f84c712230b2c592c19470d3ca8d552de726050d1d1716282a1f6146be65e"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "PyHamcrest" do
    url "https://files.pythonhosted.org/packages/58/05/7b993fabb44ff0b52a90916d96bfd91a65ecf90b8248e72bba325ba8e438/PyHamcrest-2.0.2.tar.gz"
    sha256 "412e00137858f04bde0729913874a48485665f2d36fe9ee449f26be864af9316"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/98/cd/cbc9c152daba9b5de6094a185c66f1c6eb91c507f378bb7cad83d623ea88/pyOpenSSL-20.0.1.tar.gz"
    sha256 "4c231c759543ba02560fcd2480c48dcec4dae34c9da7d3747c508227e0624b51"
  end

  resource "service_identity" do
    url "https://files.pythonhosted.org/packages/9a/3d/9eb0563e066ea0540cf580695593ab079376e920016d4d1b3ff2fd8abf4b/service_identity-18.1.0.tar.gz"
    sha256 "0858a54aabc5b459d1aafa8a518ed2081a285087f349fe3e55197989232e2e2d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "spake2" do
    url "https://files.pythonhosted.org/packages/60/0b/bb5eca8e18c38a10b1c207bbe6103df091e5cf7b3e5fdc0efbcad7b85b60/spake2-0.8.tar.gz"
    sha256 "c17a614b29ee4126206e22181f70a406c618d3c6c62ca6d6779bce95e9c926f4"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/9c/97/6627aaf69c42a41d0d22a54ad2bf420290e07da82448823dcd6851de427e/tqdm-4.55.1.tar.gz"
    sha256 "556c55b081bd9aa746d34125d024b73f0e2a0e62d5927ff0e400e20ee0a03b9a"
  end

  resource "Twisted" do
    url "https://files.pythonhosted.org/packages/4a/b4/4973c7ccb5be2ec0abc779b7d5f9d5f24b17b0349e23240cfc9dc3bd83cc/Twisted-20.3.0.tar.bz2"
    sha256 "d72c55b5d56e176563b91d11952d13b01af8725c623e498db5507b6614fc1e10"
  end

  resource "txaio" do
    url "https://files.pythonhosted.org/packages/60/2b/6c1e6a19e6142319267b8e1bd0f591fd1aab3e9b6154fb904022650a47e0/txaio-20.12.1.tar.gz"
    sha256 "1488d31d564a116538cc1265ac3f7979fb6223bb5a9e9f1479436ee2c17d8549"
  end

  resource "txtorcon" do
    url "https://files.pythonhosted.org/packages/a5/12/4d39a81dd2f60d7c54d2be5484054d668fed27741bee02ebebe55123838a/txtorcon-20.0.0.tar.gz"
    sha256 "122cd081786396f57718adda1c1a5eb01b8e9a4832fcd140918b45c10359377a"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/84/21/80cdc749908ebf2719a9063eddcc02b668fbc62d200c1f1a4d92aaaba76b/zope.interface-5.2.0.tar.gz"
    sha256 "8251f06a77985a2729a8bdbefbae79ee78567dddc3acbd499b87e705ca59fe24"
  end

  def install
    ENV["SODIUM_INSTALL"] = "system"
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resource("cffi")
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    n = rand(1e6)
    pid = fork do
      exec bin/"wormhole", "send", "--code=#{n}-homebrew-test", "--text=foo"
    end
    sleep 1
    begin
      received = shell_output("#{bin}/wormhole receive #{n}-homebrew-test")
      assert_match received, "foo\n"
    ensure
      Process.wait(pid)
    end
  end
end
