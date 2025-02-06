class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/refs/tags/1.12.0.tar.gz"
  sha256 "ff310b23b10685229468cf139feace5bc62af232f5f8560b87ca3895792941c1"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "357b80ac6eb2216b343cda7ef0bfa801c10c8bc1cba2c876cc7e52660379b04f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "357b80ac6eb2216b343cda7ef0bfa801c10c8bc1cba2c876cc7e52660379b04f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "357b80ac6eb2216b343cda7ef0bfa801c10c8bc1cba2c876cc7e52660379b04f"
    sha256 cellar: :any_skip_relocation, sonoma:        "af2d0c1ea30539d9e4f597adcc5b7aac0cfc0728875c1166e09f160e984209f6"
    sha256 cellar: :any_skip_relocation, ventura:       "af2d0c1ea30539d9e4f597adcc5b7aac0cfc0728875c1166e09f160e984209f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "357b80ac6eb2216b343cda7ef0bfa801c10c8bc1cba2c876cc7e52660379b04f"
  end

  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/d3/36/3dae1ccf058414ee9cc1d39722216db0e0430002ce5008c0b0244f1886fd/rpm-0.3.1.tar.gz"
    sha256 "d75c5dcb581f1e9c4f89cb6667e938e944c6e7c17dd96829e1553c39f3a4c961"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
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
