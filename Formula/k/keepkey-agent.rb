class KeepkeyAgent < Formula
  include Language::Python::Virtualenv

  desc "Keepkey Hardware-based SSH/GPG agent"
  homepage "https://github.com/romanz/trezor-agent"
  url "https://files.pythonhosted.org/packages/65/72/4bf47a7bc8dc93d2ac21672a0db4bc58a78ec5cee3c4bcebd0b4092a9110/keepkey_agent-0.9.0.tar.gz"
  sha256 "47c85de0c2ffb53c5d7bd2f4d2230146a416e82511259fad05119c4ef74be70c"
  license "LGPL-3.0-only"
  revision 9

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "7e90d14fa8b17a73432c81dd5263c8938d838a9c2ca07a6efe92d395ec0afd18"
    sha256 cellar: :any,                 arm64_sonoma:  "25a71155c8223d39c8771688dca8688cd393dbdd7576d2bf5c5fc422b395e0ce"
    sha256 cellar: :any,                 arm64_ventura: "bacd017684971a7c487abacccd142604b9e95dbb87feaa33f4df4708b90dcb02"
    sha256 cellar: :any,                 sonoma:        "3cb946e6ed2147b95a96498286e46cc78789e84e563d8f7b2d28746835e47da8"
    sha256 cellar: :any,                 ventura:       "1d37cf891ee502ab5651ef1dd2a9abd198424ac0968cc81637101ef17f1f17f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e400a52a8cc55f8dbbc6b782829df1ccbdde1c1a825c496d61572684d679ab7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d977a585788997b34e907e44f9857618969c795401963147cd53bc9430b09c5"
  end

  depends_on "pkgconf" => :build # for hidapi resource
  depends_on "cryptography"
  depends_on "hidapi"
  depends_on "libsodium" # for pynacl
  depends_on "libusb" # for libusb1
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "backports-shutil-which" do
    url "https://files.pythonhosted.org/packages/a0/22/51b896a4539f1bff6a7ab8514eb031b9f43f12bff23f75a4c3f4e9a666e5/backports.shutil_which-3.5.2.tar.gz"
    sha256 "fe39f567cbe4fad89e8ac4dbeb23f87ef80f7fe8e829669d0221ecdb0437c133"
  end

  resource "bech32" do
    url "https://files.pythonhosted.org/packages/ab/fe/b67ac9b123e25a3c1b8fc3f3c92648804516ab44215adb165284e024c43f/bech32-1.2.0.tar.gz"
    sha256 "7d6db8214603bd7871fcfa6c0826ef68b85b0abd90fa21c285a9c5e21d2bd899"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/ae/ed/aefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9/docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/5e/d0/ec8ac1de7accdcf18cfe468653ef00afd2f609faf67c423efbd02491051b/ecdsa-0.19.0.tar.gz"
    sha256 "60eaad1199659900dd0af521ed462b793bbdf867432b3948e87416ae4caf6bf8"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/bf/6f/90c536b020a8e860f047a2839830a1ade3e1490e67336ecf489b4856eb7b/hidapi-0.14.0.post2.tar.gz"
    sha256 "6c0e97ba6b059a309d51b495a8f0d5efbcea8756b640d98b6f6bb9fdef2458ac"
  end

  resource "keepkey" do
    url "https://files.pythonhosted.org/packages/30/38/558d9a2dd1fd74f50ff4587b4054496ffb69e21ab1138eb448f3e8e2f4a7/keepkey-6.3.1.tar.gz"
    sha256 "cef1e862e195ece3e42640a0f57d15a63086fd1dedc8b5ddfcbc9c2657f0bb1e"
  end

  resource "libagent" do
    url "https://files.pythonhosted.org/packages/33/9f/d80eb0568f617d4041fd83b8b301fdb817290503ee4c1546024df916454e/libagent-0.15.0.tar.gz"
    sha256 "c87caebdb932ed42bcd8a8cbe40ce3589587c71c3513ca79cadf7a040e24b4eb"

    # Backport replacement of pkg_resources to fix issue seen on arm64 linux
    patch do
      url "https://github.com/romanz/trezor-agent/commit/68e39c14216f466c8710bf65ef133c744f8f92da.patch?full_index=1"
      sha256 "a2b2279ba0eaf7a11d2a2e1f79155829bc8939942848b01602062f6c269b68b0"
    end
  end

  resource "libusb1" do
    url "https://files.pythonhosted.org/packages/af/19/53ecbfb96d6832f2272d13b84658c360802fcfff7c0c497ab8f6bf15ac40/libusb1-3.1.0.tar.gz"
    sha256 "4ee9b0a55f8bd0b3ea7017ae919a6c1f439af742c4a4b04543c5fd7af89b828c"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "mnemonic" do
    url "https://files.pythonhosted.org/packages/ff/77/e6232ed59fbd7b90208bb8d4f89ed5aabcf30a524bc2fb8f0dafbe8e7df9/mnemonic-0.21.tar.gz"
    sha256 "1fe496356820984f45559b1540c80ff10de448368929b9c60a2b55744cc88acf"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/55/5b/e3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bc/protobuf-3.20.3.tar.gz"
    sha256 "2e3427429c9cffebf259491be0af70189607f365c2f41c7c3764af6f337105f2"
  end

  resource "pymsgbox" do
    url "https://files.pythonhosted.org/packages/7d/ff/4c6f31a4f08979f12a663f2aeb6c8b765d3bd592e66eaaac445f547bb875/PyMsgBox-1.0.9.tar.gz"
    sha256 "2194227de8bff7a3d6da541848705a155dcbb2a06ee120d9f280a1d7f51263ff"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "python-daemon" do
    url "https://files.pythonhosted.org/packages/54/cd/d62884732e5d6ff6906234169d06338d53e37243c60cf73679c8942f9e42/python_daemon-3.1.0.tar.gz"
    sha256 "fdb621d7e5f46e74b4de1ad6b0fff6e69cd91b4f219de1476190ebdd0f4781df"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/41/6c/a536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bc/semver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/07/37/b31be7e4b9f13b59cde9dcaeff112d401d49e0dc5b37ed4a9fc8fb12f409/setuptools-75.2.0.tar.gz"
    sha256 "753bb6ebf1f465a1912e19ed1d41f403a79173a9acf66a42e7e6aec45c3c16ec"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/f7/89/19151076a006b9ac0dd37b1354e031f5297891ee507eb624755e58e10d3e/Unidecode-1.3.8.tar.gz"
    sha256 "cfdb349d46ed3873ece4586b96aa75258726e2fa8ec21d6f00a591d98806c2f4"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b7/a0/95e9e962c5fd9da11c1e28aa4c0d8210ab277b1ada951d2aee336b505813/wheel-0.44.0.tar.gz"
    sha256 "a29c3f2817e95ab89aa4660681ad547c0e9547f20e75b0562fe7723c9a2a9d49"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/keepkey-agent identity@myhost 2>&1", 1)
    assert_match "KeepKey not connected", output
  end
end
