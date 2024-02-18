class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/refs/tags/1.6.0.tar.gz"
  sha256 "7920dedfc793590829b93ddbd9dfbdbe6e2ccf471fd4f33d03117a309738b1ae"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fb2f08d8103295ab2ed173724e17ef889ad13eac1394265475d734d99f2f6c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17d38c84dc12ebcce4b4636c28ee58b80917af433135a713891a2500a973866b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51c86f9af53d93ed2265c08b225e602ee55485db9b3b0b530cce71c8f0c7915f"
    sha256 cellar: :any_skip_relocation, sonoma:         "37dce2c252546a623d1aa5390164d28546e0bde8830aac3827e3758876e8b16f"
    sha256 cellar: :any_skip_relocation, ventura:        "37c95ff0e79b47497a2005e32c0dca3b40199ca89e4dc3a996318ca867dc9bb5"
    sha256 cellar: :any_skip_relocation, monterey:       "7d3929622c4b65304d2534280069c689a9052db976cea906713459373141740d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea9c21dd423d9c99037c28174f569e0659f3afb50f954415a469ba59a3e4146d"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  uses_from_macos "curl"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
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
