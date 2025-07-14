class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/refs/tags/1.17.0.tar.gz"
  sha256 "12e1d4fcca71a5b8e23dfc6476292d6c70bdda240ac597b7664d6df7aea90469"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40ae5b66b864790321c7bdd8b0987c02e96865321f964c2ad3db98ee5d84ace8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbe7cae9149eb1e592884ec10aacead23061f0ec129e67a2d0e78d9ce520a65e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f89db80a1817eba3ade8f4cf5c8bab0fb9b285da249363b09ceefcb0a715c523"
    sha256 cellar: :any_skip_relocation, sonoma:        "95d34cda80981cbd952941efca7fd1db43a0ddd7444124a1bc1e0ffe559bfef0"
    sha256 cellar: :any_skip_relocation, ventura:       "76e0782be2a526a22e2ea9b539173309ba9c7ab525145fc8eb2b48df12f1d940"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91ee2640c2121fcb3e7c20f2aff7d26108547cf46db615d6a6a1a650c8b95402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d2d2ddd5e464a190b21b9ad7ebef8b7a576d0218498293c80ae3188f60db18d"
  end

  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/bd/ce/8db44d2b8fd6713a59e391d12b6816854b7bee8121ae7370c2d565de4265/rpm-0.4.0.tar.gz"
    sha256 "79adbefa82318e2625d6e4fa16666cf88543498a1f2c10dc3879165d1dc3ecee"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/39/87/6da0df742a4684263261c253f00edd5829e6aca970fff69e75028cccc547/ruamel.yaml-0.18.14.tar.gz"
    sha256 "7227b76aaec364df15936730efbf7d72b30c0b79b1d578bbb8e3dcb2d81f52b7"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/20/84/80203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5/ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_config = testpath/"oscrc"
    ENV["OSC_CONFIG"] = test_config

    test_config.write <<~INI
      [general]
      apiurl = https://api.opensuse.org

      [https://api.opensuse.org]
      credentials_mgr_class=osc.credentials.TransientCredentialsManager
      user=brewtest
      pass=
    INI

    output = shell_output("#{bin}/osc status 2>&1", 1).chomp
    assert_match "Directory '.' is not a working copy", output
    assert_match "Please specify a command", shell_output("#{bin}/osc 2>&1", 2)
  end
end
