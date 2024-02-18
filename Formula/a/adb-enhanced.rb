class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/82/11/1228620ea0c9204d6d908d8485005141ab3d71d3db71a152080439fa927d/adb-enhanced-2.5.22.tar.gz"
  sha256 "b829dcb4c9a9422735d416a62820de679bed8b08dfbff2014d46a525c39bc7d0"
  license "Apache-2.0"

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f140c4da6abe07762bfa5144dd612372e5cfa622cd5baa63abdd8489101ea495"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3650e94ab08fabf3e1979a3a5c3db0fe60921bd761a36031ff44a63573160b45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a0fe993a91d4e4c6e928a47c9ff88c398a1652c36cae6c2e84a0b682ccc1eda"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3802ffe0120b058bef09e5386bbd24f4dc3d6529d50cc76e2f6043682035112"
    sha256 cellar: :any_skip_relocation, ventura:        "986e44cb71e0994fc3f290771e214402d58e17b3d72cb8620e950f167f38df08"
    sha256 cellar: :any_skip_relocation, monterey:       "ad037d018263b17052c8e00ff57a61e11d71b8368bcb3aedc9ecf8985d68ab8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "907e61c009b105089aba07d6c00c4d1d1cfebbc4bb78fd9d922def97703c5e29"
  end

  depends_on "python@3.12"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/adbe --version")
    # ADB is not intentionally supplied
    # There are multiple ways to install it and we don't want dictate
    # one particular way to the end user
    assert_match(/(not found)|(No attached Android device found)/, shell_output("#{bin}/adbe devices", 1))
  end
end
