class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/56/1a/324f1bf234cc4f98445305fd8719245318466e310e05caea7ef052748ecd/dynaconf-3.2.6.tar.gz"
  sha256 "74cc1897396380bb957730eb341cc0976ee9c38bbcb53d3307c50caed0aedfb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae16a3ed04f32f1764291fe0eeeec4151d1ddd397d088c26e85934dc45c1aa91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae16a3ed04f32f1764291fe0eeeec4151d1ddd397d088c26e85934dc45c1aa91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae16a3ed04f32f1764291fe0eeeec4151d1ddd397d088c26e85934dc45c1aa91"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae16a3ed04f32f1764291fe0eeeec4151d1ddd397d088c26e85934dc45c1aa91"
    sha256 cellar: :any_skip_relocation, ventura:        "ae16a3ed04f32f1764291fe0eeeec4151d1ddd397d088c26e85934dc45c1aa91"
    sha256 cellar: :any_skip_relocation, monterey:       "ae16a3ed04f32f1764291fe0eeeec4151d1ddd397d088c26e85934dc45c1aa91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91906d1735ffd3409f662ad4395dbc5a86e59eccbcb344be99ac68d3e72aee56"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
