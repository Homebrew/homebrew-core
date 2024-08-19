class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/2b/1f/9bbf4f001befee00c050051f8f6e7971b41e2716784949989c7e856bf625/pipdeptree-2.23.1.tar.gz"
  sha256 "ebc9b232d7e8ca061826f1875fd4ccc823930f84f327d302019d2ca856f50973"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "736191dba6dc9c592451b5afe4fc2be078ebe1b2164c494697a736c5d428219a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "736191dba6dc9c592451b5afe4fc2be078ebe1b2164c494697a736c5d428219a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "736191dba6dc9c592451b5afe4fc2be078ebe1b2164c494697a736c5d428219a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e689d5b3b3b002dd57c23a4a95ea9ef1d59ac84a3a275e16a1201483cb2d98e1"
    sha256 cellar: :any_skip_relocation, ventura:        "e689d5b3b3b002dd57c23a4a95ea9ef1d59ac84a3a275e16a1201483cb2d98e1"
    sha256 cellar: :any_skip_relocation, monterey:       "e689d5b3b3b002dd57c23a4a95ea9ef1d59ac84a3a275e16a1201483cb2d98e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1b85d5d49ed46bc36be333a0cf7eb868a4106a70b48e7464e660f13ee77e4e8"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
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
