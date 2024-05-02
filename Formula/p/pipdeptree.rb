class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/2c/af/8910c2eea9dd1bd50edaf1956ea6a78ebe15b057f0bca99a47314ae8906c/pipdeptree-2.19.1.tar.gz"
  sha256 "9e68b1af1cef009e47763343fa3df795d14a367eb1b3d7c461d34a0887235d04"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59ab0e37f329bc95d184ac9fdb12db0a0bce707d35ff447740e21a53e760fe0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59ab0e37f329bc95d184ac9fdb12db0a0bce707d35ff447740e21a53e760fe0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59ab0e37f329bc95d184ac9fdb12db0a0bce707d35ff447740e21a53e760fe0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e5a34dde33b597cca53f22db079af936153fab474986967d0d1b45a96b137e6"
    sha256 cellar: :any_skip_relocation, ventura:        "4e5a34dde33b597cca53f22db079af936153fab474986967d0d1b45a96b137e6"
    sha256 cellar: :any_skip_relocation, monterey:       "4e5a34dde33b597cca53f22db079af936153fab474986967d0d1b45a96b137e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c49bf8534037bd9d53353df7b35d02f691fe1111aff0745b5c4cee13aeb7709"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
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
