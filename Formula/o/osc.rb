class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/1.3.0.tar.gz"
  sha256 "77653f92555a644f436570f9d45ea97eec63d76c0a173a154ec4232e05d11d69"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78fce6615a5df5bed73fd932a26e2377dc540ce2c8edc1230d3390384c87cf80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5e95e32c63c37404d5815bd89aa3ffce807dc2357d850419c81eaefdf7836b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7157872947b25eff8ce9e45f91b53878b8a094cb3f18d071a927b70ea12e157e"
    sha256 cellar: :any_skip_relocation, ventura:        "c5a4012003c2576704badba653ac99667618adfbdce441bcc3f955d53495d319"
    sha256 cellar: :any_skip_relocation, monterey:       "2b3c3bbf690b815b8f7383e614e4de5eb706fe42d5d9b1c412b71974ab65cc18"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a75499954038e39a94b8ab501d1f4eadfd3609e1c94ffb92bf9721b9cacf88c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a931e719c696206fd3b1f570a74a5eb1718ea0bd4a252994b86bd49d48e41554"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
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
