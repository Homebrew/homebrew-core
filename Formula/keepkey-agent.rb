class KeepkeyAgent < Formula
  include Language::Python::Virtualenv

  desc "Keepkey Hardware-based SSH/GPG agent"
  homepage "https://github.com/romanz/trezor-agent"
  url "https://files.pythonhosted.org/packages/65/72/4bf47a7bc8dc93d2ac21672a0db4bc58a78ec5cee3c4bcebd0b4092a9110/keepkey_agent-0.9.0.tar.gz"
  sha256 "47c85de0c2ffb53c5d7bd2f4d2230146a416e82511259fad05119c4ef74be70c"
  license "LGPL-3.0-only"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b24e0b0adc47e73232b625dfb0fcada42b3f4075b784b640d999b4b7190ebc46"
    sha256 cellar: :any,                 arm64_monterey: "e15107caac75189dd84abb0fb947ada153c385f54ca3e677726f99ef7b49132e"
    sha256 cellar: :any,                 arm64_big_sur:  "450aef2ddb82eba5eede13723d8716dd3a3b65c9d8305c8a5aa7c748da608a53"
    sha256 cellar: :any,                 ventura:        "c31059abd3d74075d524733d6bbac585dfa0c40575ebffbd45fdd1c28e567b5d"
    sha256 cellar: :any,                 monterey:       "96a0afd351289ba37315fde718220740da93081a0fd67e729d5ebd9248c5610d"
    sha256 cellar: :any,                 big_sur:        "18dd8e8f929e1d4b2d1054f0593317e8e14091126badcf6efcb471c7376144c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "398a5139373cea7805b82802e54eacf5460e001b82956d96a375566b31f63581"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "docutils"
  depends_on "libusb"
  depends_on "openssl@3"
  depends_on "python@3.11"
  depends_on "six"

  resource "backports.shutil_which" do
    url "https://files.pythonhosted.org/packages/a0/22/51b896a4539f1bff6a7ab8514eb031b9f43f12bff23f75a4c3f4e9a666e5/backports.shutil_which-3.5.2.tar.gz"
    sha256 "fe39f567cbe4fad89e8ac4dbeb23f87ef80f7fe8e829669d0221ecdb0437c133"
  end

  resource "bech32" do
    url "https://files.pythonhosted.org/packages/ab/fe/b67ac9b123e25a3c1b8fc3f3c92648804516ab44215adb165284e024c43f/bech32-1.2.0.tar.gz"
    sha256 "7d6db8214603bd7871fcfa6c0826ef68b85b0abd90fa21c285a9c5e21d2bd899"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/16/05/385451bc8d20a3aa1d8934b32bd65847c100849ebba397dbf6c74566b237/ConfigArgParse-1.5.3.tar.gz"
    sha256 "1b0b3cbf664ab59dada57123c81eff3d9737e0d11d8cf79e3d6eb10823f1739f"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/6a/f5/a729774d087e50fffd1438b3877a91e9281294f985bda0fd15bf99016c78/cryptography-39.0.1.tar.gz"
    sha256 "d1f6198ee6d9148405e49887803907fe8962a23e6c6f83ea7d98f1c0de375695"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/ff/7b/ba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1/ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/78/0a/d71f35a8dcbe88dab21cd668a62b688ea6dd45872feba45a97efd0452c19/hidapi-0.13.1.tar.gz"
    sha256 "99b18b28ec414ef9b604ddaed08182e486a400486f31ca56f61d537eed1d17cf"
  end

  resource "keepkey" do
    url "https://files.pythonhosted.org/packages/30/38/558d9a2dd1fd74f50ff4587b4054496ffb69e21ab1138eb448f3e8e2f4a7/keepkey-6.3.1.tar.gz"
    sha256 "cef1e862e195ece3e42640a0f57d15a63086fd1dedc8b5ddfcbc9c2657f0bb1e"
  end

  resource "libagent" do
    url "https://files.pythonhosted.org/packages/4e/0f/b48045dd9d12eea5c092aaad4c251443384da700c8d85349fc3c554a2320/libagent-0.14.7.tar.gz"
    sha256 "8cea67fbe94216f61dbc22fac9d3d749b41b9cfc11393a76b0b0013c204adb98"
  end

  resource "libusb1" do
    url "https://files.pythonhosted.org/packages/f4/83/59bf75e74e0c4859ea63eae0c7da660c1dcb78b31667d4a5f735d52f5974/libusb1-3.0.0.tar.gz"
    sha256 "5792a9defee40f15d330a40d9b1800545c32e47ba7fc66b6f28f133c9fcc8538"
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
    url "https://files.pythonhosted.org/packages/ba/dd/f8a01b146bf45ac12a829bbc599e6590aa6a6849ace7d28c42d77041d6ab/protobuf-4.21.12.tar.gz"
    sha256 "7cd532c4566d0e6feafecc1059d04c7915aec8e182d1cf7adee8b24ef1e2e6ab"
  end

  resource "PyMsgBox" do
    url "https://files.pythonhosted.org/packages/7d/ff/4c6f31a4f08979f12a663f2aeb6c8b765d3bd592e66eaaac445f547bb875/PyMsgBox-1.0.9.tar.gz"
    sha256 "2194227de8bff7a3d6da541848705a155dcbb2a06ee120d9f280a1d7f51263ff"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "python-daemon" do
    url "https://files.pythonhosted.org/packages/d9/3c/727b06abb46fead341a2bdad04ba4a4db5395c44c45d8ba0aa82b517e462/python-daemon-2.3.2.tar.gz"
    sha256 "3deeb808e72b6b89f98611889e11cc33754f5b2c1517ecfa1aaf25f402051fb5"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/31/a9/b61190916030ee9af83de342e101f192bbb436c59be20a4cb0cdb7256ece/semver-2.13.0.tar.gz"
    sha256 "fa0fe2722ee1c3f57eac478820c3a5ae2f624af8264cbdf9000c980ff7f75e3f"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/0b/25/37c77fc07821cd06592df3f18281f5e716bc891abd6822ddb9ff941f821e/Unidecode-1.3.6.tar.gz"
    sha256 "fed09cf0be8cf415b391642c2a5addfc72194407caee4f98719e40ec2a72b830"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/a2/b8/6a06ff0f13a00fc3c3e7d222a995526cbca26c1ad107691b6b1badbbabf1/wheel-0.38.4.tar.gz"
    sha256 "965f5259b566725405b05e7cf774052044b1ed30119b5d586b2703aafe8719ac"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Help gcc to find libusb headers on Linux.
    ENV.append "CFLAGS", "-I#{Formula["libusb"].opt_include}/libusb-1.0" unless OS.mac?
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/keepkey-agent identity@myhost 2>&1", 1)
    assert_match "KeepKey not connected", output
  end
end
