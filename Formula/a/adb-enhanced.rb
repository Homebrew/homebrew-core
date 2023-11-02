class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/82/11/1228620ea0c9204d6d908d8485005141ab3d71d3db71a152080439fa927d/adb-enhanced-2.5.22.tar.gz"
  sha256 "b829dcb4c9a9422735d416a62820de679bed8b08dfbff2014d46a525c39bc7d0"
  license "Apache-2.0"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbcf991278bfba5448ce602eada9d52b3e32d7bcf0647be3f660c000652c6b85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab565774036a07c0bbd16bec1e885553ef81e2c3397ac5e6dc5e32b42891f1f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baba9cf752a3e8c6ab1c0639198912077b30ec93b27b8b8b3972f44a8c6b169a"
    sha256 cellar: :any_skip_relocation, sonoma:         "563e9a24a27e970bf58325056c6e6bb8fb7473f9a367419e0016d9d38f20c5f9"
    sha256 cellar: :any_skip_relocation, ventura:        "261c053331bb35c365f6ddd5f56183cc3666529caa036d78bda854906f30bcde"
    sha256 cellar: :any_skip_relocation, monterey:       "f440d2cc3c7c6cc20e7c8a2382328bab6d57b56d912d45f25bc6fb56d56f2e6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fd029125051b0f8099c3f3a2c5ced238cd53b1cf572aa51900c478761b6b9f3"
  end

  depends_on "python-psutil"
  depends_on "python@3.12"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
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
