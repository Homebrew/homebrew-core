class KeepkeyAgent < Formula
  include Language::Python::Virtualenv

  desc "Keepkey Hardware-based SSH/GPG agent"
  homepage "https://github.com/romanz/trezor-agent"
  url "https://files.pythonhosted.org/packages/65/72/4bf47a7bc8dc93d2ac21672a0db4bc58a78ec5cee3c4bcebd0b4092a9110/keepkey_agent-0.9.0.tar.gz"
  sha256 "47c85de0c2ffb53c5d7bd2f4d2230146a416e82511259fad05119c4ef74be70c"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "3c7d8ff59d1e17131a89d51602283c6dfceaa8874eb825ebf124413798c11e34" => :catalina
    sha256 "64bd4d3444fd618a1b691a9ca1248df44547fbca438942eca67bafc677f0b7fb" => :mojave
    sha256 "cff70c223d0e5f6bbf49fdedda1aa0c5979bd987b23be768f071801945d15a7c" => :high_sierra
    sha256 "d745d85c10d037ae99221b0dbfa6bae7eee9abcc681035715f296f630dc2104f" => :sierra
    sha256 "923d1471a0285a545de011f0628e36e02566bc422b7d5d86d20af82b3e301968" => :el_capitan
  end

  depends_on "python"

  resource "backports.shutil_which" do
    url "https://files.pythonhosted.org/packages/dd/ea/715dc80584207a0ff4a693a73b03c65f087d8ad30842832b9866fe18cb2f/backports.shutil_which-3.5.1.tar.gz"
    sha256 "dd439a7b02433e47968c25a45a76704201c4ef2167deb49830281c379b1a4a9b"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/77/61/ae928ce6ab85d4479ea198488cf5ffa371bd4ece2030c0ee85ff668deac5/ConfigArgParse-0.13.0.tar.gz"
    sha256 "e6441aa58e23d3d122055808e5e2220fd742dff6e1e51082d2a4e4ed145dd788"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/f9/e5/99ebb176e47f150ac115ffeda5fedb6a3dbb3c00c74a59fd84ddf12f5857/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
  end

  resource "ed25519" do
    url "https://files.pythonhosted.org/packages/d5/d6/cd19a64022dc7557d245aad6a943eed7693189b48c58a9adf3bc00ceedc5/ed25519-1.4.tar.gz"
    sha256 "2991b94e1883d1313c956a1e3ced27b8a2fdae23ac40c0d9d0b103d5a70d1d2a"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/c1/86/89df0e8890f96eeb5fb68d4ccb14cb38e2c2d2cfd7601ba972206acd9015/hidapi-0.7.99.post21.tar.gz"
    sha256 "e0be1aa6566979266a8fc845ab0e18613f4918cf2c977fe67050f5dc7e2a9a97"
  end

  resource "keepkey" do
    url "https://files.pythonhosted.org/packages/bd/7c/8edc3d017b4b02f11533083d9987d11707fcf82ab6606c9b9aedd2e95b4c/keepkey-4.0.2.tar.gz"
    sha256 "cddee60ae405841cdff789cbc54168ceaeb2282633420f2be155554c25c69138"
  end

  resource "libagent" do
    url "https://files.pythonhosted.org/packages/63/57/39df4b80036657c9d57a17fe94902965a20543569e9bef0bb7cd89e8fa4a/libagent-0.11.2.tar.gz"
    sha256 "51f36116dacab1df8672a876bb2ddbf08a717e0afc8276406bd23aeda79d5030"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "mnemonic" do
    url "https://files.pythonhosted.org/packages/a4/5a/663362ccceb76035ad50fbc20203b6a4674be1fe434886b7407e79519c5e/mnemonic-0.18.tar.gz"
    sha256 "02a7306a792370f4a0c106c2cf1ce5a0c84b9dbd7e71c6792fdb9ad88a727f1d"
  end

  resource "pbkdf2" do
    url "https://files.pythonhosted.org/packages/02/c0/6a2376ae81beb82eda645a091684c0b0becb86b972def7849ea9066e3d5e/pbkdf2-1.3.tar.gz"
    sha256 "ac6397369f128212c43064a2b4878038dab78dab41875364554aaf2a684e6979"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/73/73/4f133a31d67b27431fe4b9cc5e2f74d0644bce0327a743093f3cc27864ce/protobuf-3.5.2.post1.tar.gz"
    sha256 "3b60685732bd0cbdc802dfcb6071efbcf5d927ce3127c13c33ea1a8efae3aa76"
  end

  resource "PyMsgBox" do
    url "https://files.pythonhosted.org/packages/b6/65/86379ede1db26c40e7972d7a41c69cdf12cc6a0f143749aabf67ab8a41a1/PyMsgBox-1.0.6.zip"
    sha256 "3888116a60812d01d44529c402014bf0896d2a9262617cb18faa9a7b3800ad4e"
  end

  resource "python-daemon" do
    url "https://files.pythonhosted.org/packages/b2/fb/a280d65f81e9d69989c8d6c4e0bb18d7280cdcd6d406a2cc3f4eb47d4402/python-daemon-2.1.2.tar.gz"
    sha256 "261c859be5c12ae7d4286dc6951e87e9e1a70a882a8b41fd926efc1ec4214f73"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/43/07/4a7470398de2d33547b54b4848d18fde88aa434883cb255e01630c8f7f65/semver-2.8.0.tar.gz"
    sha256 "b881cbbadaa83af20a6984d5e75b6db4bf388065515cf97d44661c21b80946c3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/9d/36/49d0ee152b6a1631f03a541532c6201942430060aa97fe011cf01a2cce64/Unidecode-1.0.22.tar.gz"
    sha256 "8c33dd588e0c9bc22a76eaa0c715a5434851f726131bd44a6c26471746efabf5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/keepkey-agent identity@myhost 2>&1", 1)
    assert_match "KeepKey not connected", output
  end
end
