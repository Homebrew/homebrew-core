class Libagent < Formula
  include Language::Python::Virtualenv

  desc "Library for Hardware-based SSH/GPG supporting Trezor, Ledger & Keepkey"
  homepage "https://github.com/romanz/trezor-agent/tree/master/libagent"
  url "https://files.pythonhosted.org/packages/9b/13/5e3e78890a66be778f448998368d7a17be704358a2036788a1480fe73f1c/libagent-0.13.1.tar.gz"
  sha256 "b9afa0851f668612702fcd648cee47af4dc7cfe4f86d4c4a84b1a6b4a4960b41"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b60ef8874e77323f2d1a61355f17d35b32f4c0c7b166e837aabfc9da1614236" => :mojave
    sha256 "26ffb353ec45ef5427ddb03f2425510ce9a43af1248f966780920fa0d24164fe" => :high_sierra
    sha256 "a28f6f5d0717a5eb459b09a3a3bb464cfca9e70d3dfefd08dbf8b7554ba6c91a" => :sierra
  end

  depends_on "libusb"
  depends_on "python"

  resource "libagent" do
    url "https://files.pythonhosted.org/packages/9b/13/5e3e78890a66be778f448998368d7a17be704358a2036788a1480fe73f1c/libagent-0.13.1.tar.gz"
    sha256 "b9afa0851f668612702fcd648cee47af4dc7cfe4f86d4c4a84b1a6b4a4960b41"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/93/22/953e071b589b0b1fee420ab06a0d15e5aa0c7470eb9966d60393ce58ad61/docutils-0.15.2.tar.gz"
    sha256 "a2aeea129088da402665e92e0b25b04b073c04b2dce4ab65caaa38b7ce2e1a99"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/77/61/ae928ce6ab85d4479ea198488cf5ffa371bd4ece2030c0ee85ff668deac5/ConfigArgParse-0.13.0.tar.gz"
    sha256 "e6441aa58e23d3d122055808e5e2220fd742dff6e1e51082d2a4e4ed145dd788"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/59/b0/11710a598e1e148fb7cbf9220fd2a0b82c98e94efbdecb299cb25e7f0b39/wheel-0.33.6.tar.gz"
    sha256 "10c9da68765315ed98850f8e048347c3eb06dd81822dc2ab1d4fde9dc9702646"
  end

  resource "backports.shutil_which" do
    url "https://files.pythonhosted.org/packages/a0/22/51b896a4539f1bff6a7ab8514eb031b9f43f12bff23f75a4c3f4e9a666e5/backports.shutil_which-3.5.2.tar.gz"
    sha256 "fe39f567cbe4fad89e8ac4dbeb23f87ef80f7fe8e829669d0221ecdb0437c133"
  end

  resource "python-daemon" do
    url "https://files.pythonhosted.org/packages/35/c3/50a2984169a990e329c969967d4142e9d462789876b962889d6108639937/python-daemon-2.2.3.tar.gz"
    sha256 "affeca9e5adfce2666a63890af9d6aff79f670f7511899edaddca7f96593cc25"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/51/76/139bf6e9b7b6684d5891212cdbd9e0739f2bfc03f380a1a6ffa700f392ac/ecdsa-0.13.2.tar.gz"
    sha256 "5c034ffa23413ac923541ceb3ac14ec15a0d2530690413bff58c12b80e56d884"
  end

  resource "ed25519" do
    url "https://files.pythonhosted.org/packages/58/38/72ec85c953b90552fb015f31248256ef19e89a164a40ff8fef680259a608/ed25519-1.5.tar.gz"
    sha256 "02053ee019ceef0df97294be2d4d5a8fc120fc86e81e08bec1245fc0f9403358"
  end

  resource "mnemonic" do
    url "https://files.pythonhosted.org/packages/a4/5a/663362ccceb76035ad50fbc20203b6a4674be1fe434886b7407e79519c5e/mnemonic-0.18.tar.gz"
    sha256 "02a7306a792370f4a0c106c2cf1ce5a0c84b9dbd7e71c6792fdb9ad88a727f1d"
  end

  resource "libusb1" do
    url "https://files.pythonhosted.org/packages/39/c6/a9c8c38e3a8a587cd5c32146a5156375e107e483eb2ccb80284a147921dd/libusb1-1.6.6.tar.gz"
    sha256 "a49917a2262cf7134396f6720c8be011f14aabfc5cdc53f880cc672c0f39d271"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "mnemonic" do
    url "https://files.pythonhosted.org/packages/a4/5a/663362ccceb76035ad50fbc20203b6a4674be1fe434886b7407e79519c5e/mnemonic-0.18.tar.gz"
    sha256 "02a7306a792370f4a0c106c2cf1ce5a0c84b9dbd7e71c6792fdb9ad88a727f1d"
  end

  resource "PyMsgBox" do
    url "https://files.pythonhosted.org/packages/ac/e0/0ac1ac67178a71b92e46f46788ddd799bb40bff40acd60c47c50be170374/PyMsgBox-1.0.7.tar.gz"
    sha256 "7df5ed66c8a80fd36b83b278ba164e7a1d135c8fb8bdf38b291e46bf31d28085"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/47/13/8ae74584d6dd33a1d640ea27cd656a9f718132e75d759c09377d10d64595/semver-2.8.1.tar.gz"
    sha256 "5b09010a66d9a3837211bb7ae5a20d10ba88f8cb49e92cb139a69ef90d5060d8"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/b1/d6/7e2a98e98c43cf11406de6097e2656d31559f788e9210326ce6544bd7d40/Unidecode-1.1.1.tar.gz"
    sha256 "2b6aab710c2a1647e928e36d69c21e76b453cd455f4e2621000e54b2a9b8cce8"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "pbkdf2" do
    url "https://files.pythonhosted.org/packages/02/c0/6a2376ae81beb82eda645a091684c0b0becb86b972def7849ea9066e3d5e/pbkdf2-1.3.tar.gz"
    sha256 "ac6397369f128212c43064a2b4878038dab78dab41875364554aaf2a684e6979"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("python3 -c 'import libagent' 2>&1", 1)
    assert_match "", output
  end
end
