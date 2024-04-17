class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/refs/tags/1.6.2.tar.gz"
  sha256 "05c6b0bd4dd093fe57a6760e284ef285a28e978f247d54cee5cd174d1ec9c5dd"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d45737856e50e0820118a372651a49b83633dbab58f5126b62881a0c3798f326"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d45737856e50e0820118a372651a49b83633dbab58f5126b62881a0c3798f326"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d45737856e50e0820118a372651a49b83633dbab58f5126b62881a0c3798f326"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf7ae517dbfe4b730945ae41a492fabf38c42b12d616c3b135d3707232904b4e"
    sha256 cellar: :any_skip_relocation, ventura:        "bf7ae517dbfe4b730945ae41a492fabf38c42b12d616c3b135d3707232904b4e"
    sha256 cellar: :any_skip_relocation, monterey:       "bf7ae517dbfe4b730945ae41a492fabf38c42b12d616c3b135d3707232904b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3d67c8bf585a801fbd5b0d719c7ead7686201bbec4239458d1564778ebc461d"
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
