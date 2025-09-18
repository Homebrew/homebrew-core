class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/d8/3e/0b9b4ba4f2c3318a7bc2d2cb859fe44ca49edd6b9e3b16d536986c9b53f3/adb_enhanced-2.7.0.tar.gz"
  sha256 "ae88e21ebf4954ce4fcb10a97f7298004709579bb9ce4b4d0295172948b85170"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98e868892bcb0c3971709867908809a3acb9383e55ef76ad3a1374d09c8e37a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7599187138ae1d20665239394a74eca4d8f0a15d594a9682f12afe37e55a3ca2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9630c1747d1b9acae00b8cd810f02ad988c3409cf670231dedf05cca07e0eecc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b611152bc62f009f3b50fd6d8c5d9c14919a78d78ee089ec6b45d3af5fa5857"
    sha256 cellar: :any_skip_relocation, sonoma:        "9289ef394c064f157b6940a404bc914c14bb882c349019193e3ca6b7ba178282"
    sha256 cellar: :any_skip_relocation, ventura:       "e725608c44a14fabc6d195bb52f756762008f73eea647bf41b37ec07017457e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98ed748100ec82a81dd1c131a529c0ba3b15620a552ca9010e7826444f555aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94db172517f1ff222944a13a331082e0a5c8c36f850f65b8c13a95f969bad851"
  end

  depends_on "python@3.13"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/adbe --version")
    # ADB is not intentionally supplied
    # There are multiple ways to install it and we don't want dictate
    # one particular way to the end user
    assert_match(/(not found)|(No attached Android device found)/, shell_output("#{bin}/adbe devices", 1))
  end
end
