class Aws2Wrap < Formula
  include Language::Python::Virtualenv

  desc "Script to export current AWS SSO credentials or run a sub-process with them"
  homepage "https://github.com/linaro-its/aws2-wrap"
  url "https://files.pythonhosted.org/packages/db/07/db4c98b4d44ee824ad21563910d198f0da2561a6c7cfeaef1b954979c5c6/aws2-wrap-1.3.1.tar.gz"
  sha256 "cfaee18e42f538208537c259a020263a856923520d06097e66f0e41ef404cae7"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac724aeab03c7ebfcf1dd1822e1fd0aa22ee987932eef824a3ffb087fb0a46a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32c894850f3df13aec62e6411048e7ab3eafc8f8ef2cee2debbb1d614346c8b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1eeab4596abcdffdae902f240da50dd4c6735528a2f8b9c03dd4b844bf2cd8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0333acbc490c8fe31b9b713cb9c2f1b39d90f9a0b03f4f1dd599345a136e118"
    sha256 cellar: :any_skip_relocation, ventura:        "062a4be4a0d68d3ebc90597f87f2c92b831b0bee7915d7f807663ca8c2c8c2b3"
    sha256 cellar: :any_skip_relocation, monterey:       "62bcd44742300374609bf3d82bbf6c8eff3e6576b1d50f3ace283641d1045f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "769da6fea14e74a0dda2a14b9706922add37f0533bf145d10ef56e92d9183a31"
  end

  depends_on "python@3.12"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir testpath/".aws"
    touch testpath/".aws/config"
    ENV["AWS_CONFIG_FILE"] = testpath/".aws/config"
    assert_match "Cannot find profile 'default'",
      shell_output("#{bin}/aws2-wrap 2>&1", 1).strip
  end
end
