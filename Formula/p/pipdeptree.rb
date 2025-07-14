class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/71/89/4cc997e499995cd0671ec8086508adc1099dbb87051c51d9ca575043563a/pipdeptree-2.27.0.tar.gz"
  sha256 "85ebb857b27d03fcce2818bb1e2eccf880d6fbe1082cd89dd2c61d43eba42980"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c55f2addeb78fe7170ec91de00f7948fe807549e559fea33f22c1ea2810e7ed8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c55f2addeb78fe7170ec91de00f7948fe807549e559fea33f22c1ea2810e7ed8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c55f2addeb78fe7170ec91de00f7948fe807549e559fea33f22c1ea2810e7ed8"
    sha256 cellar: :any_skip_relocation, sonoma:        "04f0410a688d41b46235c9d0cf32e2a2c6e208a58979e04c18a74b6d18ddba36"
    sha256 cellar: :any_skip_relocation, ventura:       "04f0410a688d41b46235c9d0cf32e2a2c6e208a58979e04c18a74b6d18ddba36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c55f2addeb78fe7170ec91de00f7948fe807549e559fea33f22c1ea2810e7ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c55f2addeb78fe7170ec91de00f7948fe807549e559fea33f22c1ea2810e7ed8"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
