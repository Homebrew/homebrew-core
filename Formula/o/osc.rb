class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://files.pythonhosted.org/packages/f9/f5/142dd0b53884ea61558f3643ac7d36e9a3a4276051ee55a4e6b0e3961067/osc-1.25.0.tar.gz"
  sha256 "9b536c07e03998920aa9fb7851becc206e32e0fc8f1e257edbb069f4159c7093"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bcf6655481f3d9c336d8763dfe2510b85bd35a6d93d5b5f6f0e74e1897bc723e"
  end

  depends_on "cryptography" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpm"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  pypi_packages package_name:     "",
                extra_packages:   %w[ruamel-yaml urllib3],
                exclude_packages: "cryptography"

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
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
    assert_match "Directory '.' is not a Git SCM working copy", output
    assert_match "Please specify a command", shell_output("#{bin}/osc 2>&1", 2)
  end
end
