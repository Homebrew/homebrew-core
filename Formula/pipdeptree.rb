class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/c1/a2/33531223cfebadd41e2254db8c13114295dee10ea7d5182eee5a688ec5d2/pipdeptree-2.6.0.tar.gz"
  sha256 "b0ed2685230c71ca28d35e96b09685406f6f9cc03b81b393264d2c6b14c5cf23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "deb14559e4779f7d35aef15172457b8e92215d87d35d0e1506a71a1955cfd1d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a428cd404f76b7790eca561c0e68893ad11b4cddf108dbc336715c3c2023c94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ae9e5c47d00f1f10272792a8a61efb951a363eda3b5989f0c31fdc1aed8ad6e"
    sha256 cellar: :any_skip_relocation, ventura:        "ca330dbfed64bd6d8bb3ec97943c56d99534850970179ae751330f361c22d5d7"
    sha256 cellar: :any_skip_relocation, monterey:       "c6e3bd93611fbeece6e0553e7d087557c984924f3d4ef79d17af2887c0642b12"
    sha256 cellar: :any_skip_relocation, big_sur:        "b21204f673fead436238cbbe2154ee2070fd82960878560fe483e2aef6a9544b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d83b46862bc5f41fc119f13193eb976c14298bc264f59cea3a43cfb71235df2"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
