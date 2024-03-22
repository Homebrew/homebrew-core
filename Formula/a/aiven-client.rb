class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/b3/dc/869bcceb3e6f33ebd8e7518fb70e522af975e7f3d78eda23642f640c393c/aiven_client-4.0.0.tar.gz"
  sha256 "7c3e8faaa180da457cf67bf3be76fa610986302506f99b821b529956fd61cc50"
  license "Apache-2.0"
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5084ba921af02ee8bcc6aafd1f79a9e4ff8a6b6b4baa5ebb6b83163eeadacd65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "695b185058b7d2d53d130156f417f31d0f7600c05bd38d088d02d0ac773e129c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1087da2e22c8fcc74b46ae0911752ce64f058d7c257612f6f9b26b80efa195fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ba75fc3aa78667690bcf673e83c8662eb4847f6e1d808f2445c7e41dbba6266"
    sha256 cellar: :any_skip_relocation, ventura:        "047d10bf61aa6f2282f460ec01dcc4a3a2bb3a4467e88d9513f4b30d7384d0ee"
    sha256 cellar: :any_skip_relocation, monterey:       "e983eec93701bcb365ab02e1c468ccd14a940b32a79b365432dfd9918f786cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "311a8a900c7d14dac945ec404b878693917968be43fc16981f0dd5e1f5632402"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  # Fixes `ModuleNotFoundError: No module named 'aiven.client.__main__'`
  # PR ref: https://github.com/aiven/aiven-client/pull/380
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "aiven-client", shell_output("#{bin}/avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=/tmp #{bin}/avn user info 2>&1")
  end
end
__END__
diff --git a/pyproject.toml b/pyproject.toml
index 21b6146..bfa358a 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -64,6 +64,9 @@ source = "vcs"
 [tool.hatch.build.hooks.vcs]
 version-file = "aiven/client/version.py"

+[tool.hatch.build.targets.wheel]
+packages = ["aiven"]
+
 [tool.black]
 line-length = 125
 target-version = ['py38', 'py39', 'py310', 'py311']
