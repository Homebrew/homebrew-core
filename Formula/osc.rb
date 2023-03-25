class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/1.0.1.tar.gz"
  sha256 "c8bba251b1f546fef9a9b0739c6b74df9ecca4ffd832eb9351b651c6c0033755"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ca418b649f796d8dd41bd93ec02d3312a85dec5c49daa9604ffd1f4169bb80f6"
    sha256 cellar: :any,                 arm64_monterey: "85db37e2af8a6d1b1530f99bdd9c886c3e77754b8ba194ba7da986a4e0dd4658"
    sha256 cellar: :any,                 arm64_big_sur:  "a228c4f195ff19b177a8682fe50c02aec6037834d8988e67d07cb508be859509"
    sha256 cellar: :any,                 ventura:        "675da959e16e4cab1991bbcd10b53cd802191728e034d08b7454d2863c54da65"
    sha256 cellar: :any,                 monterey:       "4b347e1ba73cd6fd73a65a42ff20849ca98340bc54d255f97f649b4823a04ee1"
    sha256 cellar: :any,                 big_sur:        "8409a54dffd20a0c25cd0a4647c9c39f82985817ebef35c5d617898d52b044d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80547b21830a8b09b01b29f1c4d1aef408c624ad67706fc41ccd89f3f6e87515"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "cffi"
  depends_on "openssl@1.1"
  depends_on "pycparser"
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/fa/f3/f4b8c175ea9a1de650b0085858059050b7953a93d66c97ed89b93b232996/cryptography-39.0.2.tar.gz"
    sha256 "bc5b871e977c8ee5a1bbc42fa8d19bcc08baf0c51cbf1586b0e87a2694dde42f"
  end

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
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
