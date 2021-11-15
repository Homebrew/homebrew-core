class KeepkeyAgent < Formula
  include Language::Python::Virtualenv

  desc "Keepkey Hardware-based SSH/GPG agent"
  homepage "https://github.com/romanz/trezor-agent"
  url "https://files.pythonhosted.org/packages/65/72/4bf47a7bc8dc93d2ac21672a0db4bc58a78ec5cee3c4bcebd0b4092a9110/keepkey_agent-0.9.0.tar.gz"
  sha256 "47c85de0c2ffb53c5d7bd2f4d2230146a416e82511259fad05119c4ef74be70c"
  license "LGPL-3.0-only"
  revision 5

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ec1b531c8705fe435f31f16fce8ad100aca11644c5d33e05df1e70056dd3121"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d666d772a79bdf2b128adcc65760f9eb9803d3e7dd17a4aba4bad155f65a1f31"
    sha256 cellar: :any_skip_relocation, monterey:       "c8dbfb2ce54eacac0cf75615bdf23dd2b5493defc5931ba53825c71a4d53fa71"
    sha256 cellar: :any_skip_relocation, big_sur:        "648c7a6bee2065718586b392941e3881e4d10d7971e785df15b63c3c51806b56"
    sha256 cellar: :any_skip_relocation, catalina:       "f5c1be64474b731cf09cd8066c0ef6b33c28a00803bef23b856a24fee92fd1f8"
    sha256 cellar: :any_skip_relocation, mojave:         "900d7ba894e9aa98c285106037db89bf3ddb1a3c08f761781d37f227f2ab960b"
  end

  depends_on "libusb"
  depends_on "python@3.10"
  depends_on "six"

  resource "backports.shutil_which" do
    url "https://files.pythonhosted.org/packages/a0/22/51b896a4539f1bff6a7ab8514eb031b9f43f12bff23f75a4c3f4e9a666e5/backports.shutil_which-3.5.2.tar.gz"
    sha256 "fe39f567cbe4fad89e8ac4dbeb23f87ef80f7fe8e829669d0221ecdb0437c133"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2e/92/87bb61538d7e60da8a7ec247dc048f7671afe17016cd0008b3b710012804/cffi-1.14.6.tar.gz"
    sha256 "c9a875ce9d7fe32887784274dd533c57909b7b1dcadcc128a2ac21331a9765dd"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/16/05/385451bc8d20a3aa1d8934b32bd65847c100849ebba397dbf6c74566b237/ConfigArgParse-1.5.3.tar.gz"
    sha256 "1b0b3cbf664ab59dada57123c81eff3d9737e0d11d8cf79e3d6eb10823f1739f"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/4c/17/559b4d020f4b46e0287a2eddf2d8ebf76318fd3bd495f1625414b052fdc9/docutils-0.17.1.tar.gz"
    sha256 "686577d2e4c32380bb50cbb22f575ed742d58168cee37e99117a854bcd88f125"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/bf/3d/3d909532ad541651390bf1321e097404cbd39d1d89c2046f42a460220fb3/ecdsa-0.17.0.tar.gz"
    sha256 "b9f500bb439e4153d0330610f5d26baaf18d17b8ced1bc54410d189385ea68aa"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/99/9b/5c41756461308a5b2d8dcbcd6eaa2f1c1bc60f0a6aa743b58cab756a92e1/hidapi-0.10.1.tar.gz"
    sha256 "a1170b18050bc57fae3840a51084e8252fd319c0fc6043d68c8501deb0e25846"
  end

  resource "keepkey" do
    url "https://files.pythonhosted.org/packages/30/38/558d9a2dd1fd74f50ff4587b4054496ffb69e21ab1138eb448f3e8e2f4a7/keepkey-6.3.1.tar.gz"
    sha256 "cef1e862e195ece3e42640a0f57d15a63086fd1dedc8b5ddfcbc9c2657f0bb1e"
  end

  resource "libagent" do
    url "https://files.pythonhosted.org/packages/84/9b/81daa642211ca088fda584c90791b7de0bbbb202725ebd5e454badd2f751/libagent-0.14.2.tar.gz"
    sha256 "62aae671df342923475323cf0677bfcef796cc48e6989039a20f29c8e4a9e5b6"
  end

  resource "libusb1" do
    url "https://files.pythonhosted.org/packages/a9/97/e8afa2af12b6de608ec86c8c4ad57f1248d98946d1b5e1aa0bff926755e9/libusb1-2.0.1.tar.gz"
    sha256 "d3ba82ecf7ab6a48d21dac6697e26504670cc3522b8e5941bd28fb56cf3f6c46"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "mnemonic" do
    url "https://files.pythonhosted.org/packages/f8/8d/d4dc2b2bddfeb57cab4404a41749b577f578f71140ab754da9afa8f5c599/mnemonic-0.20.tar.gz"
    sha256 "7c6fb5639d779388027a77944680aee4870f0fcd09b1e42a5525ee2ce4c625f6"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/ff/3e/19b09fd98ca30a9cd53269806602ffe1d32464fe1f662ec8765a215f0495/protobuf-3.18.1.tar.gz"
    sha256 "1c9bb40503751087300dd12ce2e90899d68628977905c76effc48e66d089391e"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "PyMsgBox" do
    url "https://files.pythonhosted.org/packages/7d/ff/4c6f31a4f08979f12a663f2aeb6c8b765d3bd592e66eaaac445f547bb875/PyMsgBox-1.0.9.tar.gz"
    sha256 "2194227de8bff7a3d6da541848705a155dcbb2a06ee120d9f280a1d7f51263ff"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "python-daemon" do
    url "https://files.pythonhosted.org/packages/d6/2d/f5e9a44e76777ca5c20765d92eb2d2cb89b6cfa5e921c808fdd57c90cae7/python-daemon-2.3.0.tar.gz"
    sha256 "bda993f1623b1197699716d68d983bb580043cf2b8a66a01274d9b8297b0aeaf"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/31/a9/b61190916030ee9af83de342e101f192bbb436c59be20a4cb0cdb7256ece/semver-2.13.0.tar.gz"
    sha256 "fa0fe2722ee1c3f57eac478820c3a5ae2f624af8264cbdf9000c980ff7f75e3f"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/41/a6/93288318cfae2fa0ca978dfe6bb94b22b7e9a9e98b6149a4af00b1e76ee8/Unidecode-1.3.2.tar.gz"
    sha256 "669898c1528912bcf07f9819dc60df18d057f7528271e31f8ec28cc88ef27504"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/4e/be/8139f127b4db2f79c8b117c80af56a3078cc4824b5b94250c7f81a70e03b/wheel-0.37.0.tar.gz"
    sha256 "e2ef7239991699e3355d54f8e968a21bb940a1dbf34a4d226741e64462516fad"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/keepkey-agent identity@myhost 2>&1", 1)
    assert_match "KeepKey not connected", output
  end
end
