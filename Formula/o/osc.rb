class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/refs/tags/1.16.0.tar.gz"
  sha256 "42c7d41bbb6e365a65efcb557eee7cded0bb2abeaa30c94877ebc5bc784c1076"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6549ef1d187b7c34e1cd688ad82fa78bd0c5cdba26b4506cda8ee7abdfe40954"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6549ef1d187b7c34e1cd688ad82fa78bd0c5cdba26b4506cda8ee7abdfe40954"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6549ef1d187b7c34e1cd688ad82fa78bd0c5cdba26b4506cda8ee7abdfe40954"
    sha256 cellar: :any_skip_relocation, sonoma:        "0543459f2abebc2e929b009ec039ec6a3ef97e2df0a0b410b123666eacb94c08"
    sha256 cellar: :any_skip_relocation, ventura:       "0543459f2abebc2e929b009ec039ec6a3ef97e2df0a0b410b123666eacb94c08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6549ef1d187b7c34e1cd688ad82fa78bd0c5cdba26b4506cda8ee7abdfe40954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6549ef1d187b7c34e1cd688ad82fa78bd0c5cdba26b4506cda8ee7abdfe40954"
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
    url "https://files.pythonhosted.org/packages/ea/46/f44d8be06b85bc7c4d8c95d658be2b68f27711f279bf9dd0612a5e4794f5/ruamel.yaml-0.18.10.tar.gz"
    sha256 "20c86ab29ac2153f80a428e1254a8adf686d3383df04490514ca3b79a362db58"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
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
