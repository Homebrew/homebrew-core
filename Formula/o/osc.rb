class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/refs/tags/1.7.0.tar.gz"
  sha256 "326f8e58ccc12c99a26059a60bd52c0bd3226ad5676224fbfcbf9d53ee248ac4"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a0b04f25aa783d054e113402400a00daaac8473284c40fff090b415d814d693"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b98fee216789941d84191fd15baa1e910b092222e38c0a7d2975ba9e6c0f2164"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8adc9bb1d98210f20fc1e68e980337337733eb38e0de1dcba42c46cd0d120967"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5e50d85339c53defb1ed2e0bd100dbc969440e54149700c8f7a81130b6f92d7"
    sha256 cellar: :any_skip_relocation, ventura:        "8cc558f711a436b9cf4a1dbc77a8b2f3e9516631402d1a02a3ee318cbe4dcd2a"
    sha256 cellar: :any_skip_relocation, monterey:       "3ff866d56e7300754cda85361a0167e7ed4056cbba710de1baa187d696b94937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa319b1700a4d5a9bfb5356c09815aee8e87deb6278c7dbc1a756492f55f3df5"
  end

  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_config = testpath/"oscrc"
    ENV["OSC_CONFIG"] = test_config

    test_config.write <<~EOS
      [general]
      apiurl = https://api.opensuse.org

      [https://api.opensuse.org]
      credentials_mgr_class=osc.credentials.TransientCredentialsManager
      user=brewtest
      pass=
    EOS

    output = shell_output("#{bin}/osc status 2>&1", 1).chomp
    assert_match "Directory '.' is not a working copy", output
    assert_match "Please specify a command", shell_output("#{bin}/osc 2>&1", 2)
  end
end
