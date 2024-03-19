class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/refs/tags/1.6.1.tar.gz"
  sha256 "da8d0317271335c91780ed397fd61b8d4bafff0e4e8b41f6bf88441e87c78bc8"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d0fba76c815b9dda29b4e26f0a546398fac9c100539e018be8c64cd6910f93c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8a5d98bbdaee99f4661a3e99d31f64124110b632946e2d32906ba6b7fc8eaef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c4a229d10e1ec3977c2ca5cbe9bd352c106b77e61d31b838f171bf576f022a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "2668b67fad3e8ba7665062559d6710290d0515050db88bfd606d8406692aacc5"
    sha256 cellar: :any_skip_relocation, ventura:        "e21c1ac5ae1fcc9ffe6e66f3fcb7edf0f34358141d7724b75d0ea2127b77e868"
    sha256 cellar: :any_skip_relocation, monterey:       "8aabcf04214a2fb2677f44ab306c4be82ad260bfb463477c3a38f04dc6fa2da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d776287c849c184bade5084620e7da03bc2933f4f3dd81e3392cd557824f2f9"
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
