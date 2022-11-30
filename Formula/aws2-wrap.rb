class Aws2Wrap < Formula
  include Language::Python::Virtualenv

  desc "Script to export current AWS SSO credentials or run a sub-process with them"
  homepage "https://github.com/linaro-its/aws2-wrap"
  url "https://files.pythonhosted.org/packages/db/07/db4c98b4d44ee824ad21563910d198f0da2561a6c7cfeaef1b954979c5c6/aws2-wrap-1.3.1.tar.gz"
  sha256 "cfaee18e42f538208537c259a020263a856923520d06097e66f0e41ef404cae7"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df6fced6d73b9eb47fa24c218c48ec55539a3e99fc30ed48a723adf9d60d6eb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f82b736d5ba5de2a3b658b1a791dffb3c3be8515e481c3dac766e594b35c4d3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca745ea5354ba19542c8f316d4f867c0dcf5d5b060e0d9e0ff5e73151a627470"
    sha256 cellar: :any_skip_relocation, ventura:        "7bd28c01ea36df401470b31a7fbf973a9a96c3a4c0dd7575eb087c4b0299eb9f"
    sha256 cellar: :any_skip_relocation, monterey:       "8cd21371d23b53ef788ffbf0b60fa6afa7e7884845432b3e033ac42954e47ed1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d253f490ee316da830ae2e63b7b7feecf0f8e2d2f765ef21ec21b703214b390"
    sha256 cellar: :any_skip_relocation, catalina:       "4b9ddd6d1fc1f721318de2d6881b0aadbb648ff634ecb6ed38d1b067af5b0375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f92117e20b1909b99fb9e9c6e57392a23cdd2e0cb4e897aad20fdb2d6df79bfc"
  end

  depends_on "python@3.11"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
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
