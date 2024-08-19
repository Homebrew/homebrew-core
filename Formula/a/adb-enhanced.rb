class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/8d/7d/baff371b8795aec480c607b08473502dde2dcaf4b887f22aa30c42979293/adb-enhanced-2.5.24.tar.gz"
  sha256 "1b26a774bb6de61910f9cc53cd1b6ff5480d4d69cc07dd9768712f316263920d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73049ba80f9f51c3c190cf456d999a3243ff72331ecb13a738ff121665afc07f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13919ee4ff983ed9705b02eccc0da8998b298d0ec87e1b884ce54cbe84e29862"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29c4830ae8ed9e020d149887bbf6e94ecacb9dfb5c5b8063f8ad0ec42d908f9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "aad3a353a7e4c295c968ead4b676dbdf706196c128a27e9a4ef354245f7f8e8c"
    sha256 cellar: :any_skip_relocation, ventura:        "ae9c39f55e02bbbad34a6ad763b52b87878795ad597617a33c6ee9022ba61456"
    sha256 cellar: :any_skip_relocation, monterey:       "390415b792fc76642eedb61a27c8481404d378ecdae1eecac5f575627408c6aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce41b0c1a4fbcea81a08237bdf8630bcd93e8af60420bd346c482b2401ad2267"
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
