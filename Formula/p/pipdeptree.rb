class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/74/ef/9158ee3b28274667986d39191760c988a2de22c6321be1262e21c8a19ccf/pipdeptree-2.26.1.tar.gz"
  sha256 "92a8f37ab79235dacb46af107e691a1309ca4a429315ba2a1df97d1cd56e27ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "522d354e5706c06a83b1b1b58b6967363100f003bba3761c885448b9792ccff4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "522d354e5706c06a83b1b1b58b6967363100f003bba3761c885448b9792ccff4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "522d354e5706c06a83b1b1b58b6967363100f003bba3761c885448b9792ccff4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac623f210f353911644b09784a94f5d110437ec9aaacd0bc2418cefa9cb3557d"
    sha256 cellar: :any_skip_relocation, ventura:       "ac623f210f353911644b09784a94f5d110437ec9aaacd0bc2418cefa9cb3557d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "522d354e5706c06a83b1b1b58b6967363100f003bba3761c885448b9792ccff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "522d354e5706c06a83b1b1b58b6967363100f003bba3761c885448b9792ccff4"
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
