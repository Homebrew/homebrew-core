class MagicWormhole < Formula
  include Language::Python::Virtualenv

  desc "Securely transfers data between computers"
  homepage "https://magic-wormhole.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/d7/8c/964308aeed7b828ca726da4bbfcc8f2bc89713b39ba768e24ce6331b30f3/magic_wormhole-0.24.0.tar.gz"
  sha256 "c01b4815878e5fbcad7a22cfa190c529349bf271164189a0ad955a34a8d4cde0"
  license "MIT"
  revision 6
  head "https://github.com/magic-wormhole/magic-wormhole.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c31cb1dbc8b834131ba7ab78f55659e05cb575360874b380ca7f86a600293772"
    sha256 cellar: :any, arm64_tahoe:       "e7af796fcd7c5a1fa89ae134dfc8730f092d52e608ab7b4b40879b039abc30c4"
    sha256 cellar: :any, arm64_sequoia:     "095d17360bd7b4bef7b0a4fb28b30224692f6046d6aaa7b4968ed6e74301df65"
    sha256 cellar: :any, arm64_linux:       "6e8a8e42fb9cf878a98f002a7e6beda027a992312ed3335c28f61b86e671d0a6"
    sha256 cellar: :any, x86_64_linux:      "d7844f1134a9671b3b7c34b53e32c10157793bd8c74b2a78518a254596eddacd"
  end

  depends_on "rust" => :build # for `cbor2`
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium"
  depends_on "python@3.15"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: "cryptography"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "autobahn" do
    url "https://files.pythonhosted.org/packages/e5/84/8ea0607facb3c97a3beae3c767213fc716f9ab2f157570dc5aeba1174730/autobahn-26.10.2.tar.gz"
    sha256 "6c69fca89106567060941c5568e67a5369738813d883db4e3d62b76f0a2c497e"
  end

  resource "automat" do
    url "https://files.pythonhosted.org/packages/e3/0f/d40bbe294bbf004d436a8bcbcfaadca8b5140d39ad0ad3d73d1a8ba15f14/automat-25.4.16.tar.gz"
    sha256 "0017591a5477066e90d26b0e696ddc143baafd87b588cfac8100bc6be9634de0"
  end

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/39/34/d443914ea562a985ccb357682e17b7190d5d58eff797c741379be47a8f31/cbor2-6.1.5.tar.gz"
    sha256 "6eb06160c42315ac0c4ded461c7d84d92fa18c69d13d17fc1dfc1fae96580c95"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/4d/6f/cb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324d/constantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/0a/ea/13a1ef3c12d12662905801495283530251918b70d62d368f1d2e0272c70d/humanize-4.16.0.tar.gz"
    sha256 "7dc2244a2f84a4bfb1d36c37bac80cd78e35cdc5c119206d87b018e1445f3a3f"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/ef/3c/82e84109e02c492f382c711c58a3dd91badda6d746def81a1465f74dc9f5/incremental-24.11.0.tar.gz"
    sha256 "87d3480dbb083c1d736222511a8cf380012a8176c2456d01ef483242abbbcf8c"
  end

  resource "iterable-io" do
    url "https://files.pythonhosted.org/packages/0f/c5/c3578d4ebc1f0e80c1a321b9f81a74c4486a6ad48e2a3dd1d228e3ba6199/iterable_io-1.0.4.tar.gz"
    sha256 "63b5b394aedbc61b4409a0d213130a4d153c602d1eac9dcff860a43ae0340405"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cc/52/1ec7ead2c7528bf3d1db73e886fa4df10f9e6f0eb7854a448b7090cfcef7/msgpack-1.2.4.tar.gz"
    sha256 "475c44e12f2a5de766a8448783f149c9b33f3f49b88953c6cd739a77d93c732c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/3f/e8/7325d258199b159eb2c03fe32107533e2832e70e63f4fb88a6aa00023201/pyopenssl-26.4.0.tar.gz"
    sha256 "28dfcce0162b9211413e26dfbfdf1d24317fbeba18fc93c12400a1856b2a0bc7"
  end

  resource "qrcode" do
    url "https://files.pythonhosted.org/packages/8f/b2/7fc2931bfae0af02d5f53b174e9cf701adbb35f39d69c2af63d4a39f81a9/qrcode-8.2.tar.gz"
    sha256 "35c3f2a4172b33136ab9f6b3ef1c00260dd2f66f858f24d88418a015f446506c"
  end

  resource "service-identity" do
    url "https://files.pythonhosted.org/packages/61/87/ad52e2c582c0f0e7f0a1b86950494c38d67422dc0f5ed9044a5fb9569a49/service_identity-26.1.0.tar.gz"
    sha256 "6358c52882c96e66ac4a55eb3a72c7dd4a70763f8cc6fa4e70abde2656f4bf3b"
  end

  resource "spake2" do
    url "https://files.pythonhosted.org/packages/c5/4b/32ad65f8ff5c49254e218ccaae8fc16900cfc289954fb372686159ebe315/spake2-0.9.tar.gz"
    sha256 "421fc4a8d5ac395af7af0206ffd9e6cdf188c105cb1b883d9d683312bb5a9334"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "twisted" do
    url "https://files.pythonhosted.org/packages/fe/31/a5f99ae7f1550914b0702b8f78118d95a79da20525d26fbc1b2ab42bc8ae/twisted-26.10.0.tar.gz"
    sha256 "5f0355403e507fc23ceea85e9dbb4bc59335aabde41dd324e8b8cea180dd38de"
  end

  resource "txaio" do
    url "https://files.pythonhosted.org/packages/49/de/52729cab9d2c8de679ad015e87f11f69e092d6fb3084eb9a39735df09ce7/txaio-26.6.1.tar.gz"
    sha256 "3ee900b2331c93457530fddbccc1a320c4e2d7ac8f9073d01c3fbe87762ccb35"
  end

  resource "txtorcon" do
    url "https://files.pythonhosted.org/packages/0c/59/9b868727e8a41b6b5be4c0dad15b8188b75cb9ca3162aa7cdd20b7cfa808/txtorcon-26.6.0.tar.gz"
    sha256 "0408f063a9fcb8df529daca57bb7373ea0f5b4ebaffcd5103754b7c561773f68"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/64/7c/e1fa3fb70b53192436d751b5cb671f0ee960baa188b8351a7fec735223d3/ujson-6.0.0.tar.gz"
    sha256 "80e23393feb707582e0ad495c397a4477b646d08094d2df64f7316f9fafd8aae"
  end

  resource "zipstream-ng" do
    url "https://files.pythonhosted.org/packages/f3/e0/76e5a674b0f6a6b7f90af9b87a92fbe1f2b97da447fb09078bcba6f6a28e/zipstream_ng-1.9.3.tar.gz"
    sha256 "6cebd055025699c0af594c76a9452cdf13f4be67ee005b6907f0d3c9c6f44ced"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/de/ff/a1f0021a26033da0df223fd05a7455d6d2881b67daf2c6dc897b4fe0a427/zope_interface-8.7.tar.gz"
    sha256 "0b47b62e8d0d99b24bcdd32f4f2120425e5019c3bee2ad69a0e1d75737487a96"
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
