class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/6c/52/65556a5f917a4b273fd1b705f98687a6bd721dbc45966f0f6687e90a18b0/autopep8-2.3.1.tar.gz"
  sha256 "8d6c87eba648fdcfc83e29b788910b8643171c395d9c4bcf115ece035b9c9dda"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa5eefdba927b17be6fa5cfe0b544728dd0c231ec2def405a753902228b568fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa5eefdba927b17be6fa5cfe0b544728dd0c231ec2def405a753902228b568fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa5eefdba927b17be6fa5cfe0b544728dd0c231ec2def405a753902228b568fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa5eefdba927b17be6fa5cfe0b544728dd0c231ec2def405a753902228b568fc"
    sha256 cellar: :any_skip_relocation, ventura:        "aa5eefdba927b17be6fa5cfe0b544728dd0c231ec2def405a753902228b568fc"
    sha256 cellar: :any_skip_relocation, monterey:       "aa5eefdba927b17be6fa5cfe0b544728dd0c231ec2def405a753902228b568fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56cca739cf4278dbd934677b89f0d719983c50458681ee95f2339c22e0a5ce70"
  end

  depends_on "python@3.12"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/10/56/52d8283e1a1c85695291040192776931782831e21117c84311cbdd63f70c/pycodestyle-2.12.0.tar.gz"
    sha256 "442f950141b4f43df752dd303511ffded3a04c2b6fb7f65980574f0c31e6e79c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
